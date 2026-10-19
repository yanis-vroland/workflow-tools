#!/usr/bin/env bash
# Spec 013, CA26 : répertoire sans manifeste de dépendances (brief et notes de
# FieldOps brief, ni code, ni git).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD/"
