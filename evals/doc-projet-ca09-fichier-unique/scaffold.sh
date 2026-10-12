#!/usr/bin/env bash
# FieldOps web seul (pas de monorepo), arbre propre, faux secret généré.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops-web.sh" "$PWD"
