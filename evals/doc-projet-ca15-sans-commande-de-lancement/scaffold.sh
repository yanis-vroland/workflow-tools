#!/usr/bin/env bash
# Petit projet TypeScript sans aucune commande de lancement identifiable : ni
# package.json, ni Makefile, ni commande dans le README. Code repris de FieldOps
# (src/domain/, sans le test), dans un dépôt git à un commit, rejouable.
set -euo pipefail

case_dir="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$case_dir/../.." && pwd)"
fieldops="$repo/tests/fixtures/fieldops"

mkdir -p src/domain
cp "$case_dir/projet/README.md" README.md
cp "$fieldops/src/domain/types.ts" "$fieldops/src/domain/scheduling.ts" \
  "$fieldops/src/domain/invoice.ts" src/domain/

export GIT_CONFIG_NOSYSTEM=1
export GIT_CONFIG_GLOBAL=/dev/null
export TZ=UTC
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE

g() {
  git -c core.hooksPath=/dev/null -c commit.gpgsign=false -c core.autocrlf=false "$@"
}

g init -q -b main
g add -- README.md src
export GIT_AUTHOR_NAME="Nora Belkacem" GIT_AUTHOR_EMAIL="nora.belkacem@example.invalid"
export GIT_COMMITTER_NAME="Nora Belkacem" GIT_COMMITTER_EMAIL="nora.belkacem@example.invalid"
export GIT_AUTHOR_DATE="2026-10-01T09:00:00Z" GIT_COMMITTER_DATE="2026-10-01T09:00:00Z"
g commit -q -m "chore: extraction des règles métier"
