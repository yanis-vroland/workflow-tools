#!/usr/bin/env bash
# Reconstruit la fixture FieldOps (historique git et faux secret compris) dans le
# répertoire de travail de l'eval, vide au lancement.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"
