#!/usr/bin/env bash
# Copie la fixture FieldOps brief (ni code ni git) dans le répertoire de travail
# de l'eval, vide au lancement, puis y dépose le livrable de /wf-cadrage-besoin
# (celui du cas principal, contrat de la spec 004) et un livrable de
# /wf-chiffrage écrit selon le contrat de la spec 005 (sections, tableaux,
# identifiants C01 à C13).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
case_dir="$(cd "$(dirname "$0")" && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD"
mkdir -p "$PWD/docs/wf"
cp "$repo/evals/specs-tickets-ca01-cadrage-sans-chiffrage/donnees/cadrage-besoin.md" \
  "$PWD/docs/wf/cadrage-besoin.md"
cp "$case_dir/donnees/chiffrage.md" "$PWD/docs/wf/chiffrage.md"
