#!/usr/bin/env bash
# FieldOps, puis (spec 014, CA16) :
# 1. commit de docs/wf/specs-tickets.md (T01, T02, T03, contrat de la spec 006),
#    étiqueté v1.3.0 (tag annoté) ;
# 2. commit qui modifie le seul ticket T02 (nouveau critère CA3) et la spec 002
#    (nouveau critère CA6), sans toucher au code.
# Lancée par « /wf-recette v1.3.0 », la skill ne doit produire des cas que pour
# la spec 002 et le ticket T02 : ni la spec 001 ou 003, ni T01 ou T03.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
g() {
  git -c user.name="FieldOps" -c user.email="fieldops@example.invalid" \
    -c core.hooksPath=/dev/null -c commit.gpgsign=false "$@"
}

# ticket <n> <titre> <critères (lignes Markdown)>
ticket() {
  cat <<MD
### T0$1 : $2

#### Récit utilisateur

En tant que dispatcher, je veux $3, afin de planifier sans erreur.

#### Contexte

Demande issue du cadrage.

#### Critères d'acceptation

$4

#### Hors périmètre

- Aucun.

#### Dépendances

- Aucune.

#### Besoins couverts

- B0$1

#### Estimation

non estimé

#### Fichiers concernés

- non déterminé

#### Points à clarifier

aucun

MD
}

t1_ca='- CA1 : Étant donné une intervention planifiée sans technicien, quand le dispatcher choisit un technicien dans sa fiche, alors le nom du technicien s'"'"'affiche dans la liste des interventions.'
t2_ca='- CA1 : Étant donné un technicien avec deux interventions à venir, quand le dispatcher ouvre sa fiche, alors les deux créneaux occupés s'"'"'affichent.
- CA2 : Étant donné un technicien sans intervention à venir, quand le dispatcher ouvre sa fiche, alors le message « Aucun créneau occupé » s'"'"'affiche.'
t3_ca='- CA1 : Étant donné une intervention planifiée dont l'"'"'heure de début est dépassée de plus de 30 minutes, quand le dispatcher ouvre la liste, alors elle porte la mention « En retard ».'

write_tickets() { # <critères de T02>
  {
    cat <<'MD'
# Specs et tickets : planification des techniciens

Outil : wf-specs-tickets · Date : 2026-10-01 · Commit : 2fc99c0 · Fichiers d'entrée : cadrage-besoin.md

## Synthèse

Trois tickets de planification.

## Ordre de réalisation

1. T01
2. T02
3. T03

## Tickets

MD
    ticket 1 "Affecter un technicien à une intervention" "affecter un technicien à une intervention" "$t1_ca"
    ticket 2 "Consulter les disponibilités d'un technicien" "voir les créneaux occupés d'un technicien" "$1"
    ticket 3 "Signaler les interventions en retard" "repérer les interventions en retard" "$t3_ca"
    cat <<'MD'
## Besoins non couverts

- Aucun.

## Points non déterminés

- Aucun.
MD
  } >docs/wf/specs-tickets.md
}

mkdir -p docs/wf
write_tickets "$t2_ca"
export GIT_AUTHOR_DATE="2026-10-01T09:00:00Z" GIT_COMMITTER_DATE="2026-10-01T09:00:00Z"
g add -- docs/wf/specs-tickets.md
g commit -q -m "docs: tickets de planification (wf-specs-tickets)"
g tag -a v1.3.0 -m "v1.3.0"

write_tickets "$t2_ca
- CA3 : Étant donné un technicien en congé sur une journée, quand le dispatcher ouvre sa fiche, alors la journée s'affiche comme indisponible."
cat >>docs/specs/002-ordres-de-travail.md <<'MD'
- CA6 : Étant donné un ordre de travail dont toutes les interventions sont terminées, quand l'administrateur ouvre l'ordre, alors son statut est « terminé ».
MD
export GIT_AUTHOR_DATE="2026-10-08T09:00:00Z" GIT_COMMITTER_DATE="2026-10-08T09:00:00Z"
g add -- docs/wf/specs-tickets.md docs/specs/002-ordres-de-travail.md
g commit -q -m "docs: congés des techniciens (T02) et clôture des ordres de travail"
