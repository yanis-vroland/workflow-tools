#!/usr/bin/env bash
# Génère un cahier des charges PDF fictif de deux pages, à texte extractible, dans
# le répertoire de travail de l'eval, vide au lancement.
set -euo pipefail

case_dir="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$case_dir/../.." && pwd)"
python3 "$repo/tests/fixtures/build-pdf.py" "$PWD/cahier-des-charges.pdf" \
  "$case_dir/donnees/page-1.txt" "$case_dir/donnees/page-2.txt"
