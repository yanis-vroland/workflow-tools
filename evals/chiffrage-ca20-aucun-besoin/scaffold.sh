#!/usr/bin/env bash
# Copie la fixture FieldOps brief dans le répertoire de travail de l'eval, vide au
# lancement, et y ajoute un ordre du jour sans aucun besoin fonctionnel.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
case_dir="$(cd "$(dirname "$0")" && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD"
cp "$case_dir/donnees/ordre-du-jour.md" "$PWD/ordre-du-jour.md"
