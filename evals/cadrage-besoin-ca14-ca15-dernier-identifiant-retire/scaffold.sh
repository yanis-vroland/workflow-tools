#!/usr/bin/env bash
# Copie la fixture FieldOps brief (projet pas encore démarré, ni code ni git) dans
# le répertoire de travail de l'eval, vide au lancement.
# Y ajoute le livrable d'une exécution précédente, et, dans archives/, un fichier
# de même nom que la source introuvable de l'en-tête (ancien-brief.md, attendue
# à la racine) : il ne doit pas être lu.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD"

case_dir="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$PWD/docs/wf" "$PWD/archives"
cp "$case_dir/donnees/cadrage-besoin-precedent.md" "$PWD/docs/wf/cadrage-besoin.md"
cp "$case_dir/donnees/ancien-brief.md" "$PWD/archives/ancien-brief.md"
