#!/usr/bin/env bash
# Copie la fixture FieldOps brief (projet pas encore démarré, ni code ni git) dans
# le répertoire de travail de l'eval, vide au lancement.
# Y dépose le cadrage du cas principal : le texte saisi ne doit pas être pris
# comme demande, ni être ignoré au profit du cadrage.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD"
mkdir -p "$PWD/docs/wf"
cp "$repo/evals/specs-tickets-ca01-cadrage-sans-chiffrage/donnees/cadrage-besoin.md" \
  "$PWD/docs/wf/cadrage-besoin.md"
