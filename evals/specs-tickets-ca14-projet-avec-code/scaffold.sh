#!/usr/bin/env bash
# Reconstruit la fixture FieldOps (historique git et faux secret compris) dans le
# répertoire de travail de l'eval, vide au lancement, puis y dépose un livrable
# de /wf-cadrage-besoin (contrat de la spec 004) : trois évolutions du
# back-office. docs/wf/ est ignoré par git pour que l'arbre de travail reste
# propre (commit 5b26289, sans « modifications non commitées »).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
case_dir="$(cd "$(dirname "$0")" && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"
mkdir -p "$PWD/docs/wf"
cp "$case_dir/donnees/cadrage-besoin.md" "$PWD/docs/wf/cadrage-besoin.md"
echo "docs/wf/" >>"$PWD/.git/info/exclude"
