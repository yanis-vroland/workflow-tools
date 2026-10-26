#!/usr/bin/env bash
# Copie un brief fictif et le livrable d'une exécution précédente, dont
# l'en-tête liste une source égale au délimiteur du heredoc des sources, dans le
# répertoire de travail de l'eval, vide au lancement.
set -euo pipefail

case_dir="$(cd "$(dirname "$0")" && pwd)"
cp "$case_dir/donnees/brief-atelier.md" "$PWD/brief-atelier.md"
mkdir -p "$PWD/docs/wf"
cp "$case_dir/donnees/cadrage-besoin-precedent.md" "$PWD/docs/wf/cadrage-besoin.md"
