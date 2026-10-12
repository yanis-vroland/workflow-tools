#!/usr/bin/env bash
# Place un brief fictif hors du répertoire de travail de l'eval (vide au
# lancement), dans le répertoire parent : le bac à sable de l'eval n'autorise
# la lecture que sous ce parent (home/), la session tournant dans home/cwd.
set -euo pipefail

case_dir="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$PWD/../briefs-externes"
cp "$case_dir/donnees/brief-externe.md" "$PWD/../briefs-externes/brief-externe.md"
