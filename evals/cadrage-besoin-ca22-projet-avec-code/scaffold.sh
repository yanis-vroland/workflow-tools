#!/usr/bin/env bash
# Reconstruit la fixture FieldOps (historique git et faux secret compris) dans le
# répertoire de travail de l'eval, vide au lancement, puis y ajoute le brief
# FieldOps, ignoré par git pour que l'arbre de travail reste propre.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"
cp "$repo/tests/fixtures/fieldops-brief/brief-fieldops.md" "$PWD/brief-fieldops.md"
echo "brief-fieldops.md" >>"$PWD/.git/info/exclude"
