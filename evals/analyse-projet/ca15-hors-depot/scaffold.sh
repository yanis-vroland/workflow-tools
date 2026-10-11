#!/usr/bin/env bash
# Spec 001, CA15 : projet qui n'est pas un dépôt git (copie de FieldOps sans
# historique).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../../.." && pwd)"
cp -R "$repo/tests/fixtures/fieldops/." "$PWD/"
