#!/usr/bin/env bash
# Clone superficiel (3 commits) de FieldOps (spec 009, CA23, et CA6 sans
# numéro de version) :
#   - FieldOps est construit dans un dossier temporaire, hors du répertoire de
#     l'eval, puis un commit y retire le champ version de package.json (seul
#     manifeste de la racine) ;
#   - le répertoire de l'eval en reçoit un clone de profondeur 3 : les commits
#     disponibles vont de 90668f7 à ce nouveau commit, aucun tag de version
#     n'est accessible et la borne basse attendue (v1.2.0) manque à l'historique.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
dest="$PWD"
source_dir=$(mktemp -d)
trap 'rm -r "$source_dir"' EXIT
bash "$repo/tests/fixtures/build-fieldops.sh" --no-secret "$source_dir/fieldops"

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE

g() {
  git -c core.hooksPath=/dev/null -c commit.gpgsign=false -c core.autocrlf=false "$@"
}

cd "$source_dir/fieldops"
grep -v '"version":' package.json >package.json.tmp
mv package.json.tmp package.json
g add -- package.json
export GIT_AUTHOR_NAME="Léa Marchetti" GIT_AUTHOR_EMAIL="lea.marchetti@example.invalid"
export GIT_COMMITTER_NAME="Léa Marchetti" GIT_COMMITTER_EMAIL="lea.marchetti@example.invalid"
export GIT_AUTHOR_DATE="2026-10-01T09:00:00Z" GIT_COMMITTER_DATE="2026-10-01T09:00:00Z"
g commit -q -m "chore: retrait du numéro de version du manifeste"

cd "$dest"
g clone -q --depth 3 --no-tags "file://$source_dir/fieldops" .
# Le dépôt source est supprimé à la sortie : l'origine ne mènerait nulle part
g remote remove origin
