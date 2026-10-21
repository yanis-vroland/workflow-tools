#!/usr/bin/env bash
# Spec 010, CA20 : relance sur un livrable existant.
#
# FieldOps complet, avec le livrable d'une exécution précédente commité
# (donnees/revue-securite-precedente.md) :
# - S2 (injection, src/api/routes/interventions.ts:37), S4 (DELETE sans
#   authentification) et S9 (jeton dans shared_preferences) : causes toujours
#   présentes, identifiants à conserver ;
# - S7 : porte sur src/api/routes/reports.ts, qui n'existe pas dans le projet :
#   cause disparue, entrée à retirer ;
# - S1, S3, S5, S6, S8, S10 et S11 : retirés lors d'exécutions antérieures, connus
#   seulement par la ligne « Dernier identifiant attribué : S11 » ;
# - la rawQuery interpolée de mobile/lib/db/local_db.dart et la valeur littérale
#   du secret JWT ne figurent pas dans le livrable précédent : nouveaux constats,
#   à numéroter à partir de S12.
# Lancé sans réseau (tag hors-reseau) : les dépendances restent non déterminées.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
case_dir="$(cd "$(dirname "$0")" && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

mkdir -p docs/wf
cp "$case_dir/donnees/revue-securite-precedente.md" docs/wf/revue-securite.md

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_NAME="Hugo Brassac" GIT_AUTHOR_EMAIL="hugo.brassac@example.invalid"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME" GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
export GIT_AUTHOR_DATE="2026-10-01T10:00:00Z" GIT_COMMITTER_DATE="2026-10-01T10:00:00Z"
git -c core.hooksPath=/dev/null -c commit.gpgsign=false add docs/wf/revue-securite.md
git -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -m "docs: revue de sécurité (wf-revue-securite)"
