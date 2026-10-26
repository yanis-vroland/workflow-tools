#!/usr/bin/env bash
# Spec 011, CA26 : répertoire sans code source, la fixture FieldOps brief (brief
# client et notes de réunion, ni code ni git).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD/"
