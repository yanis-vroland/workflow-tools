#!/usr/bin/env bash
# Copie un brief fictif très court (ni exclusion, ni contrainte) dans le
# répertoire de travail de l'eval, vide au lancement.
set -euo pipefail

case_dir="$(cd "$(dirname "$0")" && pwd)"
cp "$case_dir/donnees/demande-rdv.md" "$PWD/demande-rdv.md"
