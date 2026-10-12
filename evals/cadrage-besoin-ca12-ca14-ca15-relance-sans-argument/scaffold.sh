#!/usr/bin/env bash
# Copie la fixture FieldOps brief (projet pas encore démarré, ni code ni git) dans
# le répertoire de travail de l'eval, vide au lancement.
# Y ajoute le livrable d'une exécution précédente.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD"

# Livrable d'une exécution précédente (2026-09-25), avec ses identifiants B03 et
# Q02 retirés, et la réponse à Q03
# saisie à la main. Sa source compte-rendu-visio.md n'existe plus.
mkdir -p "$PWD/docs/wf"
case_dir="$(cd "$(dirname "$0")" && pwd)"
cp "$case_dir/donnees/cadrage-besoin-precedent.md" "$PWD/docs/wf/cadrage-besoin.md"
