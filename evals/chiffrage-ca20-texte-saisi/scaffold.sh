#!/usr/bin/env bash
# Copie la fixture FieldOps brief dans le répertoire de travail de l'eval, vide au
# lancement, et y dépose un livrable de cadrage valide : le texte saisi doit être
# refusé sans repli sur cette entrée par défaut.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
case_dir="$(cd "$(dirname "$0")" && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD"
mkdir -p "$PWD/docs/wf"
cp "$case_dir/donnees/cadrage-besoin.md" "$PWD/docs/wf/cadrage-besoin.md"
