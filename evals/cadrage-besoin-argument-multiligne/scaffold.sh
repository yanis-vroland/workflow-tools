#!/usr/bin/env bash
# Copie un brief fictif et le fichier notes-piege.md dans le répertoire de
# travail de l'eval, vide au lancement. notes-piege.md n'est passé qu'en
# première ligne d'un argument sur deux lignes : son contenu ne doit jamais être
# repris.
set -euo pipefail

case_dir="$(cd "$(dirname "$0")" && pwd)"
cp "$case_dir/donnees/brief-atelier.md" "$PWD/brief-atelier.md"
cp "$case_dir/donnees/notes-piege.md" "$PWD/notes-piege.md"
