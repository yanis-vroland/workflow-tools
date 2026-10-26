#!/usr/bin/env bash
# FieldOps dont la branche principale s'appelle trunk : ni origin/HEAD, ni
# branche main, ni branche master (spec 016, CA11). La branche feat/export-pdf
# existe toujours mais ne doit pas être déclarée non fusionnée.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null
git branch -m main trunk
