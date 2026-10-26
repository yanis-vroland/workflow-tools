#!/usr/bin/env bash
# Spec 008, CA5 et CA20 : FieldOps complet avec un rapport précédent
# docs/wf/rapport-avancement.md (période du 2026-08-01 au 2026-09-25), commité
# le 2026-10-02. Lancé sans argument, l'outil doit couvrir du 2026-09-26 à la
# date du jour et réécrire le fichier au lieu de le dupliquer.
set -euo pipefail

case_dir="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$case_dir/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_NAME="Léa Marchetti" GIT_AUTHOR_EMAIL="lea.marchetti@example.invalid"
export GIT_COMMITTER_NAME="Léa Marchetti" GIT_COMMITTER_EMAIL="lea.marchetti@example.invalid"
export GIT_AUTHOR_DATE="2026-10-02T08:00:00Z" GIT_COMMITTER_DATE="2026-10-02T08:00:00Z"

mkdir -p docs/wf
cp "$case_dir/donnees/rapport-avancement.md" docs/wf/rapport-avancement.md
git -c core.hooksPath=/dev/null add docs/wf/rapport-avancement.md
git -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q \
  -m "docs: rapport d'avancement jusqu'au 2026-09-25"
