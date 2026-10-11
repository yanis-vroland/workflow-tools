#!/usr/bin/env bash
# Dépose un livrable existant dans un dépôt FieldOps déjà construit et le commite
# de façon déterministe (spec 002, CA7 et CA12 : relance sur un livrable présent).
#
# Usage : bash tests/fixtures/commit-livrable.sh <source> <chemin cible> <date ISO>
#
#   <source>        fichier ou dossier à copier
#   <chemin cible>  chemin relatif au dépôt courant, ex. docs/wf/doc-projet.md
#   <date ISO>      date d'auteur et de commit, ex. 2026-10-02T10:00:00Z
#
# À lancer depuis la racine du dépôt FieldOps.
set -euo pipefail

[ $# -eq 3 ] || {
  echo "Usage : $0 <source> <chemin cible> <date ISO>" >&2
  exit 2
}
src=$1 target=$2 date=$3

export GIT_CONFIG_NOSYSTEM=1
export GIT_CONFIG_GLOBAL=/dev/null
export TZ=UTC
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE

g() {
  git -c core.hooksPath=/dev/null -c commit.gpgsign=false -c core.autocrlf=false "$@"
}

mkdir -p "$(dirname "$target")"
cp -R "$src" "$target"
g add -- "$target"

export GIT_AUTHOR_NAME="Hugo Brassac" GIT_AUTHOR_EMAIL="hugo.brassac@example.invalid"
export GIT_COMMITTER_NAME="Hugo Brassac" GIT_COMMITTER_EMAIL="hugo.brassac@example.invalid"
export GIT_AUTHOR_DATE="$date" GIT_COMMITTER_DATE="$date"
g commit -q -m "docs: documentation du projet (wf-doc-projet)"
