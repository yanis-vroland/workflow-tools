#!/usr/bin/env bash
# Spec 011, CA26 : répertoire de travail vide (ni code, ni git). Le scaffold ne
# crée rien ; il vérifie seulement que le répertoire est vide.
set -euo pipefail

if [ -n "$(ls -A .)" ]; then
  echo "Le répertoire de travail de l'eval devrait être vide." >&2
  exit 1
fi
