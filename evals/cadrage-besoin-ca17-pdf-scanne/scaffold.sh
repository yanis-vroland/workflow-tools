#!/usr/bin/env bash
# Génère un PDF de deux pages sans aucun texte extractible dans le répertoire de
# travail de l'eval, vide au lancement.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
python3 "$repo/tests/fixtures/build-pdf.py" --no-text "$PWD/brief-scanne.pdf" 2
