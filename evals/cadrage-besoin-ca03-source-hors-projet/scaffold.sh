#!/usr/bin/env bash
# Place un brief fictif hors du répertoire de travail de l'eval (vide au
# lancement), à un chemin absolu fixe, cité tel quel par le prompt. Le contenu
# est identique d'une exécution à l'autre : des exécutions simultanées peuvent
# se partager le fichier sans effet.
set -euo pipefail

case_dir="$(cd "$(dirname "$0")" && pwd)"
mkdir -p /tmp/wf-cadrage-hors-projet
cp "$case_dir/donnees/brief-externe.md" /tmp/wf-cadrage-hors-projet/brief-externe.md
