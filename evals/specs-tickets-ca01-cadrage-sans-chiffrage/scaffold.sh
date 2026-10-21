#!/usr/bin/env bash
# Copie la fixture FieldOps brief (projet pas encore démarré, ni code ni git) dans
# le répertoire de travail de l'eval, vide au lancement, puis y dépose le
# livrable de /wf-cadrage-besoin (contrat de la spec 004) : sept besoins B01 à
# B07, des questions ouvertes liées à des besoins (Q01, Q02, Q04, Q06), une
# question ouverte sans besoin (Q05) et deux questions répondues (Q03, Q07).
# Aucun livrable de chiffrage. Ce cadrage sert aussi aux cas ca09-ca10 et ca16.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
case_dir="$(cd "$(dirname "$0")" && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD"
mkdir -p "$PWD/docs/wf"
cp "$case_dir/donnees/cadrage-besoin.md" "$PWD/docs/wf/cadrage-besoin.md"
