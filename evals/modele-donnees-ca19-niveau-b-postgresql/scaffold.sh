#!/usr/bin/env bash
# Copie la fixture FieldOps brief (projet pas encore démarré, ni code ni git) dans
# le répertoire de travail de l'eval, vide au lancement, et y dépose :
# - le livrable d'une exécution précédente au niveau A (2026-10-08), dont les
#   questions bloquantes Q01 et Q03 et la décision D01 sont remplies ;
# - une ancienne migration de niveau C (migration.sql), qui n'a plus lieu d'être.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
case_dir="$(cd "$(dirname "$0")" && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD"
mkdir -p "$PWD/docs/wf/modele-donnees"
cp "$case_dir/donnees/index-niveau-a-rempli.md" "$PWD/docs/wf/modele-donnees/index.md"
cp "$case_dir/donnees/migration-ancienne.sql" "$PWD/docs/wf/modele-donnees/migration.sql"
