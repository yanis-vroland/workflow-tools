#!/usr/bin/env bash
# Copie la fixture FieldOps brief dans le répertoire de travail de l'eval, vide au
# lancement, et en fait un projet web qui dépend de Prisma, sans schéma encore
# écrit (ni schema.prisma, ni migration). Y dépose le livrable de niveau A
# rempli du cas modele-donnees-ca19-niveau-b-postgresql.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
case_dir="$(cd "$(dirname "$0")" && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD"
cp "$case_dir/donnees/package.json" "$PWD/package.json"
mkdir -p "$PWD/src"
cp "$case_dir/donnees/server.ts" "$PWD/src/server.ts"
mkdir -p "$PWD/docs/wf/modele-donnees"
cp "$repo/evals/modele-donnees-ca19-niveau-b-postgresql/donnees/index-niveau-a-rempli.md" \
  "$PWD/docs/wf/modele-donnees/index.md"
