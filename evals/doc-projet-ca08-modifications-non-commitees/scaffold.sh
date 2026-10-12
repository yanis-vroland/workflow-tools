#!/usr/bin/env bash
# FieldOps web seul avec une modification non commitée (src/domain/scheduling.ts).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops-web.sh" --dirty "$PWD"
