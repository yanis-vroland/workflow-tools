#!/usr/bin/env bash
# Spec 010, CA8, CA16 et CA17.
#
# CA8 : base d'avis OSV.dev injoignable. Le réseau de l'agent ne peut pas être
# coupé depuis le scaffold (environnement non transmis à la session) : il l'est
# par le bac à sable de Claude Code, ce cas se lançant SANS autorisation
# WebFetch(domain:…) (tag hors-reseau, voir evals/README.md). Le témoin
# ca08-temoin-echec-reseau vérifie dans la trace que l'interrogation a échoué.
#
# CA16 : un fichier d'environnement de recette, .env.staging, est suivi par git
# (ajout forcé, malgré le .gitignore de la fixture) et commité de façon
# déterministe. Sa valeur est un marqueur factice, sans format de vraie clé.
#
# CA17 : build-fieldops.sh crée en plus le fichier d'environnement local (.env,
# non suivi) avec le marqueur FIELDOPS_FAUX_SECRET_7f3a.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

printf 'STAGING_DATABASE_PASSWORD=FIELDOPS_FAUX_SECRET_STAGING_5d1c\n' >.env.staging

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_NAME="Hugo Brassac" GIT_AUTHOR_EMAIL="hugo.brassac@example.invalid"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME" GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
export GIT_AUTHOR_DATE="2026-10-01T10:00:00Z" GIT_COMMITTER_DATE="2026-10-01T10:00:00Z"
git -c core.hooksPath=/dev/null -c commit.gpgsign=false add -f .env.staging
git -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -m "chore: configuration de la recette"
