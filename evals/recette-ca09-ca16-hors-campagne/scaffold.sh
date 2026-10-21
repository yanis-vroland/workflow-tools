#!/usr/bin/env bash
# FieldOps (spec 014, CA9 et CA16, saisies humaines des cas hors campagne) :
# 1. tag annoté v1.3.0 sur le dernier commit de la fixture ;
# 2. commit d'un cahier docs/wf/recette.md issu d'une campagne précédente :
#    tableau REC-001 à REC-005 (spec 002) avec statuts et commentaires saisis,
#    « Cas hors campagne » REC-006 (spec 001, conforme) et REC-007 (spec 003,
#    bloqué), chacun avec un commentaire saisi ; dernier identifiant REC-007 ;
# 3. commit qui ajoute un critère CA7 à la spec 001.
# Lancée par « /wf-recette v1.3.0 », la skill ne produit des cas que pour la
# spec 001 : REC-006 revient au tableau avec son statut et son commentaire ;
# REC-001 à REC-005 et REC-007 sont listés sous « Cas hors campagne » avec
# leurs saisies, mot pour mot ; les nouveaux cas reçoivent REC-008 et suivants.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
g() {
  git -c user.name="FieldOps" -c user.email="fieldops@example.invalid" \
    -c core.hooksPath=/dev/null -c commit.gpgsign=false "$@"
}

export GIT_AUTHOR_DATE="2026-09-01T09:00:00Z" GIT_COMMITTER_DATE="2026-09-01T09:00:00Z"
g tag -a v1.3.0 -m "v1.3.0"

mkdir -p docs/wf
cat >docs/wf/recette.md <<'MD'
# Cahier de recette

Outil : wf-recette · Date : 2026-09-15 · Commit : 0000000
Dernier identifiant attribué : REC-007

## Périmètre et sources

Campagne limitée aux changements depuis la référence `v1.2.0` (commit `0000000`).

- Specs : `docs/specs/001-interventions.md`, `docs/specs/002-ordres-de-travail.md`, `docs/specs/003-export-pdf.md` (spec brouillon)
- Code : `src/`

## Prérequis

- Un compte par rôle.

## Cas de recette

| ID | Fonctionnalité | Préconditions | Étapes | Résultat attendu | Source | Statut | Commentaire |
|---|---|---|---|---|---|---|---|
| REC-001 | Création d'un ordre de travail | Administrateur connecté | 1. Créer un ordre avec client et adresse | L'ordre apparaît au statut « ouvert » | `docs/specs/002-ordres-de-travail.md#CA1` | conforme | OK recette du 12/09 |
| REC-002 | Facture TVA | Ordre de travail avec interventions | 1. Demander la facture | Main-d'œuvre et pièces additionnées, TVA 20 % | `docs/specs/002-ordres-de-travail.md#CA2` | non conforme | TVA calculée sur le total TTC |
| REC-003 | Frais de déplacement | Sous-total inférieur à 500 € | 1. Demander la facture | 35 € ajoutés | `docs/specs/002-ordres-de-travail.md#CA3` | bloqué | Aucun ordre de test sous 500 € |
| REC-004 | Remise fidélité | Client fidèle | 1. Demander la facture | Remise de 5 % | `docs/specs/002-ordres-de-travail.md#CA4` | à tester |  |
| REC-005 | Facture refusée au technicien | Technicien connecté | 1. Demander la facture | Accès refusé | `docs/specs/002-ordres-de-travail.md#CA5` | conforme | Refus vérifié sur mobile |

## Couverture

### Critères non recettables manuellement

- Aucun.

### Fonctionnalités sans spec

- Aucune.

### Cas hors campagne

- REC-006 : Création d'une intervention (`docs/specs/001-interventions.md#CA1`), dernier statut : conforme, dernier commentaire : Validé en démo du 10/09.
- REC-007 : Export PDF (`docs/specs/003-export-pdf.md#CA1` (spec brouillon)), dernier statut : bloqué, dernier commentaire : Maquette du PDF attendue.

### Cas retirés

- Aucun.

## Synthèse de la campagne

- à tester : 1
- conforme : 2
- non conforme : 1
- bloqué : 1
- Total : 5

## Points non déterminés

- Aucun.
MD
export GIT_AUTHOR_DATE="2026-09-30T16:00:00Z" GIT_COMMITTER_DATE="2026-09-30T16:00:00Z"
g add -- docs/wf/recette.md
g commit -q -m "docs: résultats de la campagne de recette (wf-recette)"

cat >>docs/specs/001-interventions.md <<'MD'
- CA7 : Étant donné une intervention planifiée, quand le dispatcher la réaffecte à un autre technicien, alors le nouveau technicien apparaît dans la liste.
MD
export GIT_AUTHOR_DATE="2026-10-08T09:00:00Z" GIT_COMMITTER_DATE="2026-10-08T09:00:00Z"
g add -- docs/specs/001-interventions.md
g commit -q -m "docs: réaffectation d'une intervention (spec 001)"
