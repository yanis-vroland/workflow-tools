#!/usr/bin/env bash
# FieldOps web seul, avec un livrable docs/wf/doc-projet.md déjà commité
# (ancien-livrable.md) : une section encore exacte (Présentation, rôles tirés de
# src/db/schema.sql) et une section périmée (Installation : « npm run serve »,
# absent de package.json).
set -euo pipefail

case_dir="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$case_dir/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops-web.sh" "$PWD"
bash "$repo/tests/fixtures/commit-livrable.sh" "$case_dir/ancien-livrable.md" docs/wf/doc-projet.md \
  "2026-10-02T10:00:00Z"
