#!/usr/bin/env bash
# Copie un brief fictif sans plateforme cible dans le répertoire de travail de
# l'eval, vide au lancement.
set -euo pipefail

case_dir="$(cd "$(dirname "$0")" && pwd)"
cp "$case_dir/donnees/brief-planning.md" "$PWD/brief-planning.md"
