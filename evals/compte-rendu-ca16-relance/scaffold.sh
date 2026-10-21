#!/usr/bin/env bash
# Copie la fixture FieldOps brief (ni code ni git) dans le répertoire de travail
# de l'eval, vide au lancement, puis :
#   - dépose le compte rendu produit lors d'une exécution précédente sur
#     notes/2026-10-07-point-hebdo.md, et son index ;
#   - complète les notes d'une action ajoutée depuis (Sophie, planning de recette).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
case_dir="$(cd "$(dirname "$0")" && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD"
mkdir -p docs/wf/compte-rendu
cp "$case_dir/donnees/2026-10-07-point-hebdo-fieldops.md" docs/wf/compte-rendu/
cp "$case_dir/donnees/index.md" docs/wf/compte-rendu/
printf '%s\n' "- Sophie : valider le planning de recette — pour le 12/10" >>notes/2026-10-07-point-hebdo.md
