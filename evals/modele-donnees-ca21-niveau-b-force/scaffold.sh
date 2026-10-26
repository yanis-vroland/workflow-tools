#!/usr/bin/env bash
# Copie la fixture FieldOps brief (projet pas encore démarré, ni code ni git) dans
# le répertoire de travail de l'eval, vide au lancement, et y dépose le livrable
# de niveau A du cas modele-donnees-ca10-ca11-relance-niveau-a : question
# bloquante Q03 vide.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD"
mkdir -p "$PWD/docs/wf/modele-donnees"
cp "$repo/evals/modele-donnees-ca10-ca11-relance-niveau-a/donnees/index-precedent.md" \
  "$PWD/docs/wf/modele-donnees/index.md"
