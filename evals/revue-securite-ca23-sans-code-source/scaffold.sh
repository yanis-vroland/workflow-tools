#!/usr/bin/env bash
# Répertoire sans code source : la fixture FieldOps brief (brief client et
# notes de réunion, ni code ni git) (spec 010, CA23).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD/"
