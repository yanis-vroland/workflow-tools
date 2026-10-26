#!/usr/bin/env bash
# Copie un brief fictif dans le répertoire de travail de l'eval, vide au
# lancement. Les deux autres arguments du prompt ne sont pas des fichiers.
set -euo pipefail

case_dir="$(cd "$(dirname "$0")" && pwd)"
cp "$case_dir/donnees/brief-atelier.md" "$PWD/brief-atelier.md"
