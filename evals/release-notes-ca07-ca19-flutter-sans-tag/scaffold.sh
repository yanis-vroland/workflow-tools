#!/usr/bin/env bash
# FieldOps réduit à son application Flutter, placée à la racine du dépôt, sans
# aucun tag de version (spec 009, CA7 et CA19) :
#   - historique complet de FieldOps, tags v1.0.0 à v1.2.0 supprimés ;
#   - dernier commit « refactor » : seul le contenu de mobile/ est conservé, à la
#     racine, et le pubspec.yaml passe en version 1.4.0+42 (numéro de build).
# Plus de package.json : le seul manifeste de la racine est pubspec.yaml.
# Sans fichier d'environnement local (--no-secret) : sans le .gitignore de la
# racine, il apparaîtrait comme fichier non suivi.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" --no-secret "$PWD"

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE

g() {
  git -c core.hooksPath=/dev/null -c commit.gpgsign=false -c core.autocrlf=false "$@"
}

g tag -d v1.0.0 v1.1.0 v1.2.0 >/dev/null

# Retrait de tout ce qui n'est pas dans mobile/, puis remontée de mobile/ à la racine
g rm -r -q -- . ':(exclude)mobile'
while IFS= read -r -d '' file; do
  target=${file#mobile/}
  mkdir -p "$(dirname "$target")"
  g mv -- "$file" "$target"
done < <(g ls-files -z -- mobile)
find mobile -depth -type d -empty -exec rmdir {} \;
sed 's/^version: .*/version: 1.4.0+42/' pubspec.yaml >pubspec.yaml.tmp
mv pubspec.yaml.tmp pubspec.yaml
g add -- pubspec.yaml

export GIT_AUTHOR_NAME="Nora Belkacem" GIT_AUTHOR_EMAIL="nora.belkacem@example.invalid"
export GIT_COMMITTER_NAME="Nora Belkacem" GIT_COMMITTER_EMAIL="nora.belkacem@example.invalid"
export GIT_AUTHOR_DATE="2026-10-01T09:00:00Z" GIT_COMMITTER_DATE="2026-10-01T09:00:00Z"
g commit -q -m "refactor: application mobile seule à la racine du dépôt"
