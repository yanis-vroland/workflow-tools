#!/usr/bin/env bash
# Copie la fixture FieldOps brief (ni code ni git, sans livrable de cadrage) dans
# le répertoire de travail de l'eval, vide au lancement, et y ajoute un cahier des
# charges brut dans un sous-dossier.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
case_dir="$(cd "$(dirname "$0")" && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD"
mkdir -p "$PWD/entrees-client"
cp "$case_dir/donnees/cahier-des-charges.md" "$PWD/entrees-client/cahier-des-charges.md"
