#!/usr/bin/env bash
# Reconstruit la fixture FieldOps complète (monorepo web JS/TS et Flutter,
# historique git, faux secret) dans le répertoire de travail de l'eval, vide au
# lancement. Arbre de travail propre, aucun rapport de couverture, aucun
# livrable docs/wf/ préexistant.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"
