#!/usr/bin/env bash
# FieldOps web seul (build-fieldops-web.sh) : API et back-office JS/TS, aucune
# application mobile (ni Flutter, ni React Native, ni projet natif). Spec 015,
# CA5 : l'outil l'indique et n'écrit aucun livrable.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops-web.sh" "$PWD"
