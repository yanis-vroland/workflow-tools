#!/usr/bin/env bash
# Spec 008, CA19 et CA6 : FieldOps complet dont la branche principale s'appelle
# « master » (ni origin/HEAD, ni main : repli sur master). La période demandée
# (2026-10-01 au 2026-10-05) ne contient aucun commit, ni sur master (dernier
# commit le 2026-09-29) ni sur feat/export-pdf (dernier commit le 2026-09-30).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null
git branch -m main master
