#!/usr/bin/env bash
# Copie la fixture FieldOps brief (ni code ni git) dans le répertoire de travail
# de l'eval, vide au lancement, puis y crée un fichier de notes vide.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD"
: >notes/2026-10-21-point-hebdo.md
