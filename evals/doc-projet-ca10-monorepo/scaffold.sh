#!/usr/bin/env bash
# FieldOps complet (monorepo web et Flutter), arbre propre, faux secret généré.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"
