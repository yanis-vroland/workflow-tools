#!/usr/bin/env bash
# Spec 008, CA6 : FieldOps complet dont la branche principale s'appelle
# « develop » : ni origin/HEAD, ni main, ni master. L'outil doit demander la
# branche principale et n'écrire aucun livrable.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null
git branch -m main develop
