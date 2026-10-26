#!/usr/bin/env bash
# Copie la fixture FieldOps brief (ni code ni git) dans le répertoire de travail
# de l'eval, vide au lancement, puis y dépose un cadrage mis à jour (2026-10-15)
# et le livrable de chiffrage d'une exécution précédente (2026-10-01).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
case_dir="$(cd "$(dirname "$0")" && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD"
mkdir -p "$PWD/docs/wf"
cp "$case_dir/donnees/cadrage-besoin.md" "$PWD/docs/wf/cadrage-besoin.md"
cp "$case_dir/donnees/chiffrage-precedent.md" "$PWD/docs/wf/chiffrage.md"
