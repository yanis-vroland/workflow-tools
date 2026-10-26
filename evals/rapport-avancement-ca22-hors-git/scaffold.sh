#!/usr/bin/env bash
# Spec 008, CA22 : copie de FieldOps sans historique git. claude plugin eval
# crée lui-même un dépôt git sans commit dans le dossier parent de la session :
# ce dépôt vide ne fait pas du projet un dépôt git exploitable.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
cp -R "$repo/tests/fixtures/fieldops/." "$PWD"
