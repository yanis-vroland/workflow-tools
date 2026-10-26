#!/usr/bin/env bash
# Reconstruit la fixture FieldOps (historique git, tags v1.0.0 à v1.2.0, branche
# non fusionnée feat/export-pdf, faux secret local) dans le répertoire de
# travail de l'eval, vide au lancement. Arbre de travail propre, aucun livrable
# docs/wf/ préexistant.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"
