#!/usr/bin/env bash
# Spec 001, CA12 : livrable déjà présent. Une analyse précédente (2026-10-01,
# commit 5b26289, dernier commit de main de la fixture) a produit
# docs/wf/analyse-projet.md, que l'utilisateur a commité. La relance doit mettre
# à jour ce fichier (date et commit d'en-tête) au lieu d'en créer un autre.
#
# Le commit du livrable est déterministe (auteur, date et configuration fixés) :
# son hash court est vérifié par le correcteur ca12-en-tete-commit-actualise.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

mkdir -p docs/wf
cat >docs/wf/analyse-projet.md <<'MD'
# Analyse du projet

Outil : wf-analyse-projet · Date : 2026-10-01 · Commit analysé : 5b26289

## Synthèse

Projet FieldOps : API et back-office web (Node.js, Express, React) et
application compagnon Flutter. Reprise envisageable, dette concentrée sur les
routes des interventions.

## Stack et dépendances

- `react` 17.0.2 (`package-lock.json`).
- `express` 4.18.2 (`package-lock.json`).

## Architecture

### Application web (racine)

API Express dans `src/api/`, back-office React dans `src/web/`.

### Application mobile (`mobile/`)

Application Flutter, écrans dans `mobile/lib/screens/`.

## Activité du dépôt

Dernier commit : 2026-09-29.

## Qualité et tests

Fichier non couvert : `src/api/routes/interventions.ts`. Heuristique
approximative.

## Sécurité

Requête SQL concaténée dans `src/api/routes/interventions.ts`.

## Dette et risques

- Élevé : `src/api/routes/interventions.ts`, point chaud non testé.

## Effort de reprise

Moyen, du fait du risque élevé sur les interventions.

## Points non déterminés

- Hébergement de production : non déterminé.
MD

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_NAME="Léa Marchetti" GIT_AUTHOR_EMAIL="lea.marchetti@example.invalid"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME" GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
export GIT_AUTHOR_DATE="2026-10-01T10:00:00Z" GIT_COMMITTER_DATE="2026-10-01T10:00:00Z"
git -c core.hooksPath=/dev/null -c commit.gpgsign=false add docs/wf/analyse-projet.md
git -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -m "docs: analyse du projet (wf-analyse-projet)"
