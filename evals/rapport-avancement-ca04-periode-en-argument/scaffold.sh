#!/usr/bin/env bash
# Spec 008, cas principal : FieldOps complet (historique git, faux secret local),
# avec les livrables d'entrée commités le 2026-10-01 (hors de la période) :
# docs/wf/specs-tickets.md (tickets T01, T02, T03, T07, T10) et deux comptes
# rendus, l'un dans la période (2026-02-10), l'autre hors période (2025-11-05).
# Arbre de travail propre.
set -euo pipefail

case_dir="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$case_dir/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_NAME="Léa Marchetti" GIT_AUTHOR_EMAIL="lea.marchetti@example.invalid"
export GIT_COMMITTER_NAME="Léa Marchetti" GIT_COMMITTER_EMAIL="lea.marchetti@example.invalid"
export GIT_AUTHOR_DATE="2026-10-01T09:00:00Z" GIT_COMMITTER_DATE="2026-10-01T09:00:00Z"

mkdir -p docs/wf
cp -R "$case_dir/donnees/wf/." docs/wf/
git -c core.hooksPath=/dev/null add docs/wf
git -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q \
  -m "docs: tickets et comptes rendus de réunion"
