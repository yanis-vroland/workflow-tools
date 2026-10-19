#!/usr/bin/env bash
# Copie la fixture FieldOps brief (ni code ni git) dans le répertoire de travail
# de l'eval, vide au lancement, puis y ajoute des notes au format .docx (contenu
# texte : seul l'extension compte, le fichier ne doit pas être ouvert).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
case_dir="$(cd "$(dirname "$0")" && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD"
cp "$case_dir/donnees/2026-10-21-point-hebdo.docx" notes/2026-10-21-point-hebdo.docx
