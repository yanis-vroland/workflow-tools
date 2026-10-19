#!/usr/bin/env bash
# Reconstruit FieldOps (historique git et faux secret compris) dans le répertoire
# de travail de l'eval, vide au lancement, puis :
#   - dépose deux comptes rendus déjà produits et leur index dans
#     docs/wf/compte-rendu/, exclus de git pour que l'arbre reste propre
#     (le commit analysé reste 5b26289) ;
#   - place les notes de la réunion hors du projet, dans ../reunions/ (le bac à
#     sable de l'eval autorise la lecture sous le parent du répertoire de session).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
case_dir="$(cd "$(dirname "$0")" && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

mkdir -p docs/wf/compte-rendu
cp "$case_dir/donnees/2026-10-14-revue-de-sprint.md" docs/wf/compte-rendu/
cp "$case_dir/donnees/2026-09-30-atelier-parcours-technicien.md" docs/wf/compte-rendu/
cp "$case_dir/donnees/index.md" docs/wf/compte-rendu/
echo "docs/wf/" >>.git/info/exclude

mkdir -p ../reunions
cp "$case_dir/donnees/notes-reunion.md" ../reunions/notes-reunion.md
