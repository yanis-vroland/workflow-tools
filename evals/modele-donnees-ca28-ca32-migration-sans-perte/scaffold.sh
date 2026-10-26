#!/usr/bin/env bash
# Reconstruit la fixture FieldOps (historique git et faux secret compris) dans le
# répertoire de travail de l'eval, vide au lancement, et place une demande
# d'évolution fictive à côté, dans ../demandes/ : le bac à sable de l'eval
# n'autorise la lecture que sous ce parent, la session tournant dans home/cwd.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
case_dir="$(cd "$(dirname "$0")" && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"
mkdir -p "$PWD/../demandes"
cp "$case_dir/donnees/evolution-interventions.md" "$PWD/../demandes/evolution-interventions.md"
