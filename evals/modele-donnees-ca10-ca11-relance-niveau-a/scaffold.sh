#!/usr/bin/env bash
# Copie la fixture FieldOps brief (projet pas encore démarré, ni code ni git) dans
# le répertoire de travail de l'eval, vide au lancement, et y dépose le livrable
# d'une exécution précédente au niveau A (2026-10-01) : réponse à Q01 et décision
# D01 saisies à la main, question bloquante Q03 encore vide.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
case_dir="$(cd "$(dirname "$0")" && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD"
mkdir -p "$PWD/docs/wf/modele-donnees"
cp "$case_dir/donnees/index-precedent.md" "$PWD/docs/wf/modele-donnees/index.md"
