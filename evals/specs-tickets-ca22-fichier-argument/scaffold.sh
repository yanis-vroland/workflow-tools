#!/usr/bin/env bash
# Copie la fixture FieldOps brief (projet pas encore démarré, ni code ni git) dans
# le répertoire de travail de l'eval, vide au lancement.
# Y ajoute un cahier des charges fictif, avec adresses e-mail et numéros de
# téléphone, dans besoins/. Aucun livrable docs/wf/.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD"
case_dir="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$PWD/besoins"
cp "$case_dir/donnees/cahier-des-charges-export.md" "$PWD/besoins/cahier-des-charges-export.md"
