#!/usr/bin/env bash
# FieldOps avec un cahier de recette docs/wf/recette.md d'une campagne
# précédente, commité (spec 014, CA9, CA10). Statuts et commentaires saisis à
# la main sur REC-001 à REC-003, REC-005, REC-007 et REC-010 ; REC-004 encore
# « à tester ».
# - REC-010 cite une spec supprimée depuis (005-notifications-sms) et REC-011 un
#   critère qui n'existe plus (002#CA7) : ils doivent être retirés et listés
#   sous « Cas retirés » avec leur dernier statut.
# - REC-012 avait été retiré lors d'une campagne antérieure (ligne « Dernier
#   identifiant attribué : REC-012 ») : jamais réattribué.
# - Les critères 002#CA2, 002#CA4 et la spec 003 n'ont pas encore de cas : les
#   nouveaux cas reçoivent REC-013 et suivants.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

mkdir -p docs/wf
cat >docs/wf/recette.md <<'MD'
# Cahier de recette

Outil : wf-recette · Date : 2026-09-15 · Commit : 0000000
Dernier identifiant attribué : REC-012

## Périmètre et sources

- Specs : `docs/specs/001-interventions.md`, `docs/specs/002-ordres-de-travail.md`, `docs/specs/005-notifications-sms.md`
- Code : `src/`, `mobile/lib/`

## Prérequis

- Un compte par rôle.

## Cas de recette

| ID | Fonctionnalité | Préconditions | Étapes | Résultat attendu | Source | Statut | Commentaire |
|---|---|---|---|---|---|---|---|
| REC-001 | Création d'une intervention | Dispatcher connecté, un ordre de travail ouvert | Créer une intervention avec ordre de travail, adresse et date de début | L'intervention apparaît au statut « Planifiée » | `docs/specs/001-interventions.md#CA1` | conforme | RAS sur la recette du 12/09 |
| REC-002 | Création refusée sans date | Dispatcher connecté | Valider une intervention sans date de début | Création refusée avec un message d'erreur | `docs/specs/001-interventions.md#CA2` | non conforme | Aucun message affiché, le formulaire se vide |
| REC-003 | Filtre par statut | Interventions de plusieurs statuts | Filtrer la liste sur « En cours » | Seules les interventions en cours s'affichent | `docs/specs/001-interventions.md#CA3` | bloqué | Liste vide sur l'environnement de recette, données à recharger |
| REC-004 | Démarrage depuis le mobile | Technicien connecté sur l'application mobile | Démarrer une intervention planifiée | Statut « En cours » | `docs/specs/001-interventions.md#CA4` | à tester |  |
| REC-005 | Retour arrière interdit | Intervention terminée | Tenter de la repasser « En cours » | Changement refusé | `docs/specs/001-interventions.md#CA5` | conforme | Vérifié avec le chef d'équipe |
| REC-006 | Envoi du compte rendu | Intervention clôturée avec compte rendu | Clôturer l'intervention | Le client reçoit le compte rendu par e-mail | `docs/specs/001-interventions.md#CA6` | à tester |  |
| REC-007 | Création d'un ordre de travail | Administrateur connecté | Créer un ordre avec client et adresse | L'ordre apparaît au statut « ouvert » | `docs/specs/002-ordres-de-travail.md#CA1` | conforme | OK |
| REC-008 | Frais de déplacement | Ordre de travail dont le sous-total est inférieur à 500 € | Demander la facture | 35 € de déplacement ajoutés | `docs/specs/002-ordres-de-travail.md#CA3` | à tester |  |
| REC-009 | Facture refusée au technicien | Technicien connecté | Demander la facture d'un ordre | Accès refusé | `docs/specs/002-ordres-de-travail.md#CA5` | à tester |  |
| REC-010 | Notification SMS au client | Intervention planifiée | Démarrer l'intervention | Le client reçoit un SMS | `docs/specs/005-notifications-sms.md#CA1` | non conforme | SMS jamais reçu |
| REC-011 | Export comptable | Ordre de travail facturé | Exporter la facture | Fichier CSV téléchargé | `docs/specs/002-ordres-de-travail.md#CA7` | bloqué | Bouton absent |

## Couverture

### Critères non recettables manuellement

- Aucun.

### Fonctionnalités sans spec

- `src/api/routes/technicians.ts`
- `src/api/routes/auth.ts`

### Cas retirés

- REC-012 : Rappel de rendez-vous (`docs/specs/005-notifications-sms.md#CA2`), dernier statut : à tester.

## Synthèse de la campagne

| Statut | Nombre |
|---|---|
| à tester | 4 |
| conforme | 3 |
| non conforme | 2 |
| bloqué | 2 |
| Total | 11 |

## Points non déterminés

- Aucun.
MD

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_DATE="2026-09-30T16:00:00Z" GIT_COMMITTER_DATE="2026-09-30T16:00:00Z"
git add -- docs/wf/recette.md
git -c user.name="FieldOps" -c user.email="fieldops@example.invalid" \
  -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q \
  -m "docs: résultats de la campagne de recette (wf-recette)"
