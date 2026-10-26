#!/usr/bin/env bash
# Spec 013, CA23 : FieldOps avec un livrable docs/wf/montee-version.md déjà
# présent et commité, issu d'une exécution précédente. Il est périmé : react y
# est installé en 16.14.0 (package-lock.json contient 17.0.2) et l'en-tête date
# du 2026-01-15.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_DATE="2026-01-15T12:00:00Z" GIT_COMMITTER_DATE="2026-01-15T12:00:00Z"

mkdir -p docs/wf
cat >docs/wf/montee-version.md <<'MD'
# Plan de montée de version de FieldOps

Outil : wf-montee-version · Date : 2026-01-15 · Commit : 0000000

## Synthèse

- Dépendances : 1 majeur, 0 mineur, 0 correctif, 0 à jour.
- Plan : 1 étape.
- Effort global : **faible**, aucune rupture identifiée.

## Inventaire des versions

### Application web (racine, npm d'après `package-lock.json`)

| Dépendance | Contrainte déclarée | Installée | Dernière publiée | Écart | Usage |
|---|---|---|---|---|---|
| `react` | `^16.14.0` | 16.14.0 | 17.0.2 | majeur | `dependencies` |

## Cibles retenues

1. `react` 16.14.0 → 17.0.2.

## Ruptures et impacts

Aucune rupture.

## Plan de montée

### Étape 1 : react 17

- Paquets : `react` 16.14.0 → 17.0.2
- Commandes : `npm install react@17.0.2`
- Ruptures à traiter : aucune
- Vérification avant l'étape suivante : `npm test`

## Vérifications

- `npm test` (`package.json`)

## Points non déterminés

- Aucun.
MD

git add -- docs/wf/montee-version.md
git -c user.name="FieldOps" -c user.email="fieldops@example.invalid" \
  -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -m "docs: plan de montée de version (wf-montee-version)"
