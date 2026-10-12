#!/usr/bin/env bash
# Spec 001, CA14 : répertoire sans code source (brief et notes de FieldOps brief,
# ni code, ni git).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../../.." && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD/"
