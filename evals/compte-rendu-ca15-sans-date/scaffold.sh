#!/usr/bin/env bash
# Copie la fixture FieldOps brief (ni code ni git) dans le répertoire de travail
# de l'eval, vide au lancement, puis y ajoute des notes fictives sans aucune date.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
case_dir="$(cd "$(dirname "$0")" && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD"
cp "$case_dir/donnees/reunion-chantier.md" notes/reunion-chantier.md
