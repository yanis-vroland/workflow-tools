#!/usr/bin/env bash
# Répertoire de travail vide : ni code, ni git (spec 010, CA23).
# Le scaffold ne crée rien ; il vérifie seulement que le répertoire est vide.
set -euo pipefail

if [ -n "$(ls -A .)" ]; then
  echo "Le répertoire de travail de l'eval devrait être vide." >&2
  exit 1
fi
