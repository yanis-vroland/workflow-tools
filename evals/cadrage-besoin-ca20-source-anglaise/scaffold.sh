#!/usr/bin/env bash
# Copie un brief fictif rédigé en anglais dans le répertoire de travail de l'eval,
# vide au lancement.
set -euo pipefail

case_dir="$(cd "$(dirname "$0")" && pwd)"
cp "$case_dir/donnees/brief-en.md" "$PWD/brief-en.md"
