#!/usr/bin/env bash
# Reconstruit la fixture FieldOps complète (historique git et faux secret
# compris) dans le répertoire de travail de l'eval, vide au lancement : API et
# back-office web à la racine, application compagnon Flutter dans mobile/.
# Arbre de travail propre, aucun livrable docs/wf/ préexistant (ni
# publication-store.md, ni release-notes.md), aucune métadonnée de store.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"
