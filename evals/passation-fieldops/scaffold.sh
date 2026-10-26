#!/usr/bin/env bash
# Reconstruit la fixture FieldOps (historique git et faux secret compris) dans le
# répertoire de travail de l'eval, vide au lancement. Arbre de travail propre,
# aucun livrable docs/wf/ préexistant (spec 016).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"
