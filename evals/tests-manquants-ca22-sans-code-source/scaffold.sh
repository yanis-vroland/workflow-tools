#!/usr/bin/env bash
# Spec 012, CA22 : copie la fixture FieldOps brief (brief client et notes de
# réunion), ni code source ni git.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD/"
