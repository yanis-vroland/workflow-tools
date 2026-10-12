#!/usr/bin/env bash
# Génère un PDF de deux pages dont le texte, dessiné en formes, est lisible à
# l'œil mais non extractible (document scanné), dans le répertoire de travail
# de l'eval, vide au lancement.
set -euo pipefail

case_dir="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$case_dir/../.." && pwd)"
python3 "$repo/tests/fixtures/build-pdf.py" --no-text "$PWD/brief-scanne.pdf" \
  "$case_dir/donnees/page-1.txt" "$case_dir/donnees/page-2.txt"
