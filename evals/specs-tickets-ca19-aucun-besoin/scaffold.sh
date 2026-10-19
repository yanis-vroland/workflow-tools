#!/usr/bin/env bash
# Copie la fixture FieldOps brief (projet pas encore démarré, ni code ni git) dans
# le répertoire de travail de l'eval, vide au lancement.
# Y ajoute un fichier d'organisation d'atelier, sans aucun besoin fonctionnel.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD"
case_dir="$(cd "$(dirname "$0")" && pwd)"
cp "$case_dir/donnees/organisation-atelier.md" "$PWD/organisation-atelier.md"
