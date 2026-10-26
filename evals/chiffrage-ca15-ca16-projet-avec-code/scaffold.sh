#!/usr/bin/env bash
# Reconstruit la fixture FieldOps (historique git et faux secret compris) dans le
# répertoire de travail de l'eval, vide au lancement, puis y dépose les livrables
# de wf-cadrage-besoin (spec 004, daté du 2026-10-10) et de wf-analyse-projet
# (spec 001). docs/wf/ est ignoré par git pour que l'arbre de travail reste propre.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
case_dir="$(cd "$(dirname "$0")" && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"
mkdir -p "$PWD/docs/wf"
cp "$case_dir/donnees/cadrage-besoin.md" "$PWD/docs/wf/cadrage-besoin.md"
cp "$case_dir/donnees/analyse-projet.md" "$PWD/docs/wf/analyse-projet.md"
echo "docs/wf/" >>"$PWD/.git/info/exclude"
