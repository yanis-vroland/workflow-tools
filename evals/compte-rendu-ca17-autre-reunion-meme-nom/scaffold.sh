#!/usr/bin/env bash
# Copie la fixture FieldOps brief (ni code ni git) dans le répertoire de travail
# de l'eval, vide au lancement, puis :
#   - dépose un compte rendu existant du 2026-10-07, objet « Point hebdomadaire »,
#     tiré des notes point-hebdo-equipe-nord.md, et son index ;
#   - ajoute les notes d'une autre réunion du même jour, au même objet.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
case_dir="$(cd "$(dirname "$0")" && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD"
mkdir -p docs/wf/compte-rendu
cp "$case_dir/donnees/2026-10-07-point-hebdomadaire.md" docs/wf/compte-rendu/
cp "$case_dir/donnees/index.md" docs/wf/compte-rendu/
cp "$case_dir/donnees/point-hebdo-equipe-sud.md" notes/point-hebdo-equipe-sud.md
