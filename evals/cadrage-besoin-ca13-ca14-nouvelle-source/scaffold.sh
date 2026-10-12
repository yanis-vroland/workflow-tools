#!/usr/bin/env bash
# Copie la fixture FieldOps brief (projet pas encore démarré, ni code ni git) dans
# le répertoire de travail de l'eval, vide au lancement.
# Y ajoute le livrable d'une exécution précédente et la réponse du client.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD"

# Livrable d'une exécution précédente (2026-09-25), avec ses identifiants B03 et
# Q02 retirés. Aucune réponse saisie.
mkdir -p "$PWD/docs/wf"
case_dir="$(cd "$(dirname "$0")" && pwd)"
cp "$case_dir/donnees/cadrage-besoin-precedent.md" "$PWD/docs/wf/cadrage-besoin.md"
cp "$case_dir/donnees/reponse-client.md" "$PWD/reponse-client.md"
