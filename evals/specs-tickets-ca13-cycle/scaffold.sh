#!/usr/bin/env bash
# Copie la fixture FieldOps brief (projet pas encore démarré, ni code ni git) dans
# le répertoire de travail de l'eval, vide au lancement.
# Y dépose un livrable de /wf-cadrage-besoin (contrat de la spec 004) dont les
# contraintes imposent un ordre circulaire entre B01 et B02, B03 dépendant des
# deux.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD"
case_dir="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$PWD/docs/wf"
cp "$case_dir/donnees/cadrage-besoin.md" "$PWD/docs/wf/cadrage-besoin.md"
