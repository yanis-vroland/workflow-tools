#!/usr/bin/env bash
# Répertoire de travail vide : ni code, ni git (spec 003, CA17).
# Le scaffold ne crée rien ; il vérifie seulement que le répertoire est vide.
set -euo pipefail

if [ -n "$(ls -A .)" ]; then
  echo "Le répertoire de travail de l'eval devrait être vide." >&2
  exit 1
fi
