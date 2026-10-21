#!/usr/bin/env bash
# FieldOps (tags v1.0.0, v1.1.0, v1.2.0 seulement) avec un cahier de recette
# précédent commité (spec 014, CA17) : lancée avec la référence inexistante
# v9.9.9, la skill ne doit ni écrire ni modifier docs/wf/recette.md.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

mkdir -p docs/wf
cat >docs/wf/recette.md <<'MD'
# Cahier de recette

Outil : wf-recette · Date : 2026-09-15 · Commit : 0000000
Dernier identifiant attribué : REC-001

## Périmètre et sources

- Specs : `docs/specs/001-interventions.md`

## Prérequis

- Aucun.

## Cas de recette

| ID | Fonctionnalité | Préconditions | Étapes | Résultat attendu | Source | Statut | Commentaire |
|---|---|---|---|---|---|---|---|
| REC-001 | Création d'une intervention | Dispatcher connecté | Créer une intervention | Statut « Planifiée » | `docs/specs/001-interventions.md#CA1` | conforme | Vérifié |

## Couverture

### Critères non recettables manuellement

- Aucun.

### Fonctionnalités sans spec

- Aucune.

### Cas retirés

- Aucun.

## Synthèse de la campagne

- à tester : 0
- conforme : 1
- non conforme : 0
- bloqué : 0
- Total : 1

## Points non déterminés

- Aucun.
MD
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_DATE="2026-09-30T16:00:00Z" GIT_COMMITTER_DATE="2026-09-30T16:00:00Z"
git add -- docs/wf/recette.md
git -c user.name="FieldOps" -c user.email="fieldops@example.invalid" \
  -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q \
  -m "docs: résultats de la campagne de recette (wf-recette)"
