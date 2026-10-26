#!/usr/bin/env bash
# Copie la fixture FieldOps brief dans le répertoire de travail de l'eval, vide au
# lancement, et y dépose un livrable de cadrage valide, ainsi qu'un fichier
# besoin.md : l'argument piégé doit être refusé sans repli sur l'un ou l'autre.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
case_dir="$(cd "$(dirname "$0")" && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD"
mkdir -p "$PWD/docs/wf"
cp "$case_dir/donnees/cadrage-besoin.md" "$PWD/docs/wf/cadrage-besoin.md"
cp "$repo/tests/fixtures/fieldops-brief/brief-fieldops.md" "$PWD/besoin.md"
