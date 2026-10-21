#!/usr/bin/env bash
# Reconstruit la fixture FieldOps avec une modification non commitée
# (--dirty, src/domain/scheduling.ts), sans fichier d'environnement, puis y
# dépose le cadrage du cas CA14 (contrat de la spec 004). docs/wf/ est ignoré
# par git : seule la modification de --dirty rend l'arbre « non propre ».
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" --dirty --no-secret "$PWD"
mkdir -p "$PWD/docs/wf"
cp "$repo/evals/specs-tickets-ca14-projet-avec-code/donnees/cadrage-besoin.md" \
  "$PWD/docs/wf/cadrage-besoin.md"
echo "docs/wf/" >>"$PWD/.git/info/exclude"
