#!/usr/bin/env bash
# FieldOps avec, commités par-dessus l'historique de la fixture (spec 014, CA5,
# CA11) :
# - docs/wf/specs-tickets.md, livrable de wf-specs-tickets conforme au contrat
#   de la spec 006 (sous-sections « Tnn : <titre> », rubrique « Critères
#   d'acceptation » numérotée CA1, CA2… dans chaque ticket). T02-CA3 décrit un
#   comportement interne (cache serveur), non vérifiable à la main ;
# - docs/specs/004-liste-des-interventions.md, dont CA2 porte sur une
#   performance mesurée (95e centile du temps de réponse).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

mkdir -p docs/wf
cat >docs/wf/specs-tickets.md <<'MD'
# Specs et tickets : planification des techniciens

Outil : wf-specs-tickets · Date : 2026-10-01 · Commit : 2fc99c0 · Fichiers d'entrée : cadrage-besoin.md

## Synthèse

Trois tickets pour affecter les techniciens aux interventions, consulter leurs disponibilités et relancer les interventions en retard.

## Ordre de réalisation

1. T01
2. T02
3. T03

## Tickets

### T01 : Affecter un technicien à une intervention

#### Récit utilisateur

En tant que dispatcher, je veux affecter un technicien à une intervention planifiée, afin qu'il la voie dans son application.

#### Contexte

Aujourd'hui, l'affectation se fait par téléphone.

#### Critères d'acceptation

- CA1 : Étant donné une intervention planifiée sans technicien, quand le dispatcher choisit un technicien dans la fiche de l'intervention, alors le nom du technicien s'affiche dans la liste des interventions.
- CA2 : Étant donné un technicien déjà affecté à une intervention sur le même créneau, quand le dispatcher l'affecte à une seconde intervention qui chevauche la première, alors l'affectation est refusée avec le message « Technicien indisponible sur ce créneau ».

#### Hors périmètre

- Affectation automatique.

#### Dépendances

- Aucune.

#### Besoins couverts

- B02

#### Estimation

non estimé

#### Fichiers concernés

- `src/api/routes/interventions.ts`

#### Points à clarifier

aucun

### T02 : Consulter les disponibilités d'un technicien

#### Récit utilisateur

En tant que dispatcher, je veux voir les créneaux occupés d'un technicien, afin de planifier sans conflit.

#### Contexte

Les créneaux occupés sont calculés à partir des interventions à venir.

#### Critères d'acceptation

- CA1 : Étant donné un technicien avec deux interventions à venir, quand le dispatcher ouvre sa fiche, alors les deux créneaux occupés s'affichent avec leurs heures de début et de fin.
- CA2 : Étant donné un technicien sans intervention à venir, quand le dispatcher ouvre sa fiche, alors le message « Aucun créneau occupé » s'affiche.
- CA3 : Étant donné une demande de disponibilités, quand le serveur la calcule, alors le résultat est conservé en cache mémoire côté serveur pendant 5 minutes et réutilisé pour les demandes suivantes.

#### Hors périmètre

- Synchronisation avec un agenda externe.

#### Dépendances

- T01

#### Besoins couverts

- B03

#### Estimation

non estimé

#### Fichiers concernés

- `src/api/routes/technicians.ts`

#### Points à clarifier

aucun

### T03 : Signaler les interventions en retard

#### Récit utilisateur

En tant que dispatcher, je veux repérer les interventions dont l'heure de début est dépassée sans qu'elles aient démarré, afin de relancer le technicien.

#### Contexte

Aucun signalement n'existe aujourd'hui.

#### Critères d'acceptation

- CA1 : Étant donné une intervention planifiée dont l'heure de début est dépassée de plus de 30 minutes, quand le dispatcher ouvre la liste des interventions, alors elle est affichée avec la mention « En retard ».

#### Hors périmètre

- Notification par SMS.

#### Dépendances

- Aucune.

#### Besoins couverts

- B04

#### Estimation

non estimé

#### Fichiers concernés

- `src/web/pages/InterventionList.tsx`

#### Points à clarifier

aucun

## Besoins non couverts

- Aucun.

## Points non déterminés

- Aucun.
MD

cat >docs/specs/004-liste-des-interventions.md <<'MD'
# Spec 004 : performance de la liste des interventions

Statut : validée
Date : 2026-09-28

## Besoin

En tant que dispatcher, je veux que la liste des interventions reste utilisable avec un historique important, afin de travailler sans attente.

## Critères d'acceptation

- CA1 : Étant donné plus de 50 interventions, quand le dispatcher ouvre la liste, alors elle est paginée par 50 et un bouton « Page suivante » donne accès aux suivantes.
- CA2 : Étant donné une base de 100 000 interventions et 50 utilisateurs simultanés, alors le 95e centile du temps de réponse de `GET /api/interventions` est inférieur à 300 ms, mesuré par un test de charge.
MD

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_DATE="2026-10-01T09:00:00Z" GIT_COMMITTER_DATE="2026-10-01T09:00:00Z"
git add -- docs/wf/specs-tickets.md docs/specs/004-liste-des-interventions.md
git -c user.name="FieldOps" -c user.email="fieldops@example.invalid" \
  -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q \
  -m "docs: tickets de planification et spec 004 de la liste des interventions"
