#!/usr/bin/env bash
# Spec 013, CA8 : FieldOps complet, arbre propre, faux secret ; la cible est passée en argument (prompt.md).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"
