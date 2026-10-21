#!/usr/bin/env bash
# Copie la fixture FieldOps brief (ni code ni git) dans le répertoire de travail
# de l'eval, vide au lancement, puis y dépose :
# - le livrable de /wf-cadrage-besoin du cas principal (B01 à B07) ;
# - un livrable de wf-specs-tickets d'une exécution précédente (2026-10-10),
#   produit quand le cadrage ne comptait que B01 à B04 : tickets T01, T02, T04,
#   T05, dernier identifiant attribué T06 (T03 et T06 supprimés depuis), et
#   ticket T02 dont le critère CA2 a été supprimé (CA1 et CA3 restent).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
case_dir="$(cd "$(dirname "$0")" && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD"
mkdir -p "$PWD/docs/wf"
cp "$repo/evals/specs-tickets-ca01-cadrage-sans-chiffrage/donnees/cadrage-besoin.md" \
  "$PWD/docs/wf/cadrage-besoin.md"
cp "$case_dir/donnees/specs-tickets-precedent.md" "$PWD/docs/wf/specs-tickets.md"
