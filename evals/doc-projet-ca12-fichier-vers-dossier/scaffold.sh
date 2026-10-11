#!/usr/bin/env bash
# FieldOps complet (monorepo), avec un livrable au format fichier unique
# docs/wf/doc-projet.md déjà commité (ancien-livrable.md), qui ne décrit que
# l'application web.
set -euo pipefail

case_dir="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$case_dir/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"
bash "$repo/tests/fixtures/commit-livrable.sh" "$case_dir/ancien-livrable.md" docs/wf/doc-projet.md \
  "2026-10-02T10:00:00Z"
