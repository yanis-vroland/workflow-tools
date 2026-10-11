#!/usr/bin/env bash
# Spec 001, CA13 : répertoire de travail non propre (modification non commitée
# dans src/domain/scheduling.ts).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" --dirty "$PWD"
