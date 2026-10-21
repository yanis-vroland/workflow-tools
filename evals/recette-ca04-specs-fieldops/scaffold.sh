#!/usr/bin/env bash
# Reconstruit la fixture FieldOps (historique git et faux secret compris) dans le
# répertoire de travail de l'eval, vide au lancement. Arbre de travail propre,
# aucun livrable docs/wf/ préexistant. Specs : 001 et 002 validées, 003 en
# brouillon (spec 014, CA4, CA13).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"
