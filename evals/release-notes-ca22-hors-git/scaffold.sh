#!/usr/bin/env bash
# Copie de la fixture FieldOps sans historique git (spec 009, CA22). Le dépôt
# vide que claude plugin eval crée dans le dossier parent n'a aucun commit : le
# projet n'a donc aucun historique exploitable.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
cp -R "$repo/tests/fixtures/fieldops/." "$PWD"
