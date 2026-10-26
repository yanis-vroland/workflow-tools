#!/usr/bin/env bash
# FieldOps dont le dernier commit porte un tag de version (v1.3.0) : sans
# argument, la plage va de ce tag (exclu) à HEAD (inclus) et ne contient aucun
# commit (spec 009, CA20).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_COMMITTER_DATE="2026-10-01T09:00:00Z"
git -c user.name="Léa Marchetti" -c user.email="lea.marchetti@example.invalid" \
  -c tag.gpgsign=false tag -a v1.3.0 -m "Version 1.3.0"
