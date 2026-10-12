#!/usr/bin/env bash
# FieldOps web seul (n'est plus un monorepo), avec un livrable au format dossier
# docs/wf/doc-projet/ déjà commité (ancien-livrable/), produit quand le dépôt
# contenait encore l'application Flutter.
set -euo pipefail

case_dir="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$case_dir/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops-web.sh" "$PWD"
bash "$repo/tests/fixtures/commit-livrable.sh" "$case_dir/ancien-livrable" docs/wf/doc-projet \
  "2026-10-02T10:00:00Z"
