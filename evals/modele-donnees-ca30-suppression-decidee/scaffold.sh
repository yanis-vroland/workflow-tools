#!/usr/bin/env bash
# Reconstruit la fixture FieldOps (historique git et faux secret compris) dans le
# répertoire de travail de l'eval, vide au lancement, place la demande
# d'évolution du cas modele-donnees-ca28-ca32-migration-sans-perte dans
# ../demandes/, et dépose le livrable d'une exécution précédente au niveau C
# (2026-10-10), dont la décision D01 confirme la suppression de hourly_rate.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
case_dir="$(cd "$(dirname "$0")" && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"
mkdir -p "$PWD/../demandes"
cp "$repo/evals/modele-donnees-ca28-ca32-migration-sans-perte/donnees/evolution-interventions.md" \
  "$PWD/../demandes/evolution-interventions.md"
mkdir -p "$PWD/docs/wf/modele-donnees"
cp "$case_dir/donnees/index-niveau-c.md" "$PWD/docs/wf/modele-donnees/index.md"
