#!/usr/bin/env bash
# Copie la fixture FieldOps brief (ni code ni git) dans le répertoire de travail
# de l'eval, vide au lancement, puis y ajoute une transcription fictive en
# anglais, horodatée, datée par son nom de fichier.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
case_dir="$(cd "$(dirname "$0")" && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD"
cp "$case_dir/donnees/2026-10-21-weekly-sync.txt" notes/2026-10-21-weekly-sync.txt
