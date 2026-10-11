#!/usr/bin/env bash
# FieldOps avec un guide docs/wf/onboarding.md déjà présent et commité, issu
# d'une exécution précédente (spec 003, CA16). Il contient des informations
# toujours vraies (Flutter 3.13.9, npm run db:seed, WorkOrder) et une
# information périmée (Node.js 16.20.0, alors que .nvmrc contient 18.19.0).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

# commit_paths <message> <chemin>… : commit déterministe, sans configuration de la machine
commit_paths() {
  local message=$1
  shift
  export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
  export GIT_AUTHOR_DATE="2026-01-15T12:00:00Z" GIT_COMMITTER_DATE="2026-01-15T12:00:00Z"
  git add -- "$@"
  git -c user.name="FieldOps" -c user.email="fieldops@example.invalid" \
    -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -m "$message"
}

mkdir -p docs/wf
cat >docs/wf/onboarding.md <<'MD'
# Guide de prise en main de FieldOps

Outil : wf-onboarding · Date : 2026-01-15 · Commit : 0000000

Ce guide a été établi par lecture des fichiers, sans exécution des commandes : les étapes n'ont pas été vérifiées.

## Avant de commencer

- Node.js 16.20.0 (`.nvmrc`)
- Flutter 3.13.9 (`mobile/.fvmrc`)

## Installer le projet

1. `npm install` (`README.md`)

## Lancer le projet

1. `npm run db:seed` : charge les données de démonstration (`package.json`).

## Vérifier l'installation

1. `npm test` (`package.json`)

## Se repérer dans le code

1. `src/api/server.ts` : point d'entrée de l'API.

## Contribuer

Lint : `npm run lint` (`package.json`, `.eslintrc.json`).

## Glossaire métier

- `WorkOrder` : la demande du client, qui peut donner lieu à plusieurs interventions (`src/domain/types.ts`).

## Pour aller plus loin

Aucun livrable de wf-doc-projet : lancer `/wf-doc-projet`.

## Points non déterminés

- Aucun.
MD

commit_paths "docs: guide de prise en main (wf-onboarding)" docs/wf/onboarding.md
