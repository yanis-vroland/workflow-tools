#!/usr/bin/env bash
# Répertoire sans code source ni spec : la fixture FieldOps brief (brief client
# et notes de réunion, ni code ni git) (spec 014, CA19).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD/"
