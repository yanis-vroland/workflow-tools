#!/usr/bin/env bash
# Copie la fixture FieldOps brief (projet pas encore démarré, ni code ni git) dans
# le répertoire de travail de l'eval, vide au lancement. Les notes d'entrée sont
# celles de la fixture : notes/2026-10-07-point-hebdo.md.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD"
