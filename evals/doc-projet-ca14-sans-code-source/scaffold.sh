#!/usr/bin/env bash
# Copie la fixture FieldOps brief : documents seulement, ni code source ni git.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD/"
