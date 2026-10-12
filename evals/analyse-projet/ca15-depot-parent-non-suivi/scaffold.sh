#!/usr/bin/env bash
# Spec 001, CA15, frontière de CA20 : le projet est situé sous un dépôt git
# parent qui a des commits mais ne le suit pas (ex. dossier personnel versionné
# où le projet n'est qu'ignoré). Seul un sous-dossier suivi par le dépôt relève
# de CA20 ; ici le projet est « hors git ».
#
# Comme pour ca20-sous-dossier, le scaffold n'écrit rien au-dessus de $PWD : le
# répertoire git est $PWD/.git et sa racine de travail le dossier parent
# (core.worktree). Le dépôt ne suit que plateforme/ (jamais extrait) et ignore
# tout le reste du dossier parent, dont $PWD (.git/info/exclude).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../../.." && pwd)"
here="$(pwd -P)"
parent="$(dirname "$here")"

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
export GIT_AUTHOR_NAME="Inès Carmo" GIT_AUTHOR_EMAIL="ines.carmo@example.invalid"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME" GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"

g() {
  git -c core.hooksPath=/dev/null -c commit.gpgsign=false -c core.autocrlf=false "$@"
}

# Dépôt de construction, hors de $PWD : un seul dossier suivi, plateforme/
build="$(mktemp -d)"
g init -q -b main "$build/mono"
mkdir -p "$build/mono/plateforme"
for i in 1 2 3; do
  export GIT_AUTHOR_DATE="2026-10-0${i}T09:00:00Z" GIT_COMMITTER_DATE="2026-10-0${i}T09:00:00Z"
  printf 'echo "étape %s"\n' "$i" >>"$build/mono/plateforme/deploy-commun.sh"
  g -C "$build/mono" add plateforme/deploy-commun.sh
  g -C "$build/mono" commit -q -m "chore(plateforme): étape $i du déploiement commun"
done

# FieldOps, non suivi, dans $PWD
cp -R "$repo/tests/fixtures/fieldops/." "$here/"

# Dépôt final : répertoire git dans $PWD, racine de travail au-dessus
g init -q -b main
g config core.worktree "$parent"
g config core.sparseCheckout true
# extraction limitée au dossier du projet, que le dépôt ne suit pas : rien
# n'est extrait, plateforme/ reste dans l'historique seulement
printf '/%s/\n' "$(basename "$here")" >.git/info/sparse-checkout
printf '/*\n!/plateforme/\n' >>.git/info/exclude
g fetch -q "$build/mono" main
g checkout -q -f -B main FETCH_HEAD

chmod -R u+w "$build"
rm -r "$build"

# Contrôles : dans un dépôt avec commits, mais aucun fichier du projet suivi
if [ "$(g rev-parse --is-inside-work-tree)" != true ] || ! g rev-parse -q --verify HEAD >/dev/null; then
  echo "Erreur interne : dépôt parent absent ou sans commit." >&2
  exit 1
fi
if [ -n "$(g ls-files -- .)" ] || [ -n "$(g status --porcelain)" ] || [ -e "$parent/plateforme" ]; then
  echo "Erreur interne : le dépôt parent suit le projet ou n'est pas propre." >&2
  exit 1
fi
