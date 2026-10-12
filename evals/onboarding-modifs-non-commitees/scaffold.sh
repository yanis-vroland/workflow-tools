#!/usr/bin/env bash
# FieldOps avec une modification non commitée dans src/domain/scheduling.ts
# (spec 003, CA15 : mention « modifications non commitées » dans l'en-tête).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" --dirty "$PWD"
