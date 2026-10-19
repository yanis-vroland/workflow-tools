# Cadrage du besoin : évolutions du back-office FieldOps

- Outil : wf-cadrage-besoin
- Date : 2026-10-13
- Commit analysé : 5b26289
- Sources lues : ../demandes/demande-evolutions.md
- Derniers identifiants attribués : B03, Q02

## Synthèse

Le responsable d'exploitation demande trois évolutions du back-office : l'export PDF du compte rendu d'une intervention terminée, le filtrage de la liste des interventions par technicien et la désactivation d'un technicien qui quitte l'entreprise. Le contenu du PDF (Q01) et le devenir des interventions futures d'un technicien désactivé (Q02) restent à clarifier.

## Contexte et objectifs

- Les comptes rendus sont aujourd'hui envoyés au client par copier-coller (demande-evolutions.md, « Contexte »).

## Utilisateurs et rôles

- Dispatchers : consultent et filtrent la liste des interventions, exportent les comptes rendus (demande-evolutions.md, « Demandes »).
- Administrateur : gère les techniciens (demande-evolutions.md, « Demandes »).

## Besoins fonctionnels

- B01 : Export en PDF du compte rendu d'une intervention terminée. Priorité : indispensable. Source : demande-evolutions.md, « Demandes ».
- B02 : Filtrage de la liste des interventions par technicien. Priorité : important. Source : demande-evolutions.md, « Demandes ».
- B03 : Désactivation d'un technicien qui quitte l'entreprise, sans perdre l'historique de ses interventions. Priorité : non précisée. Source : demande-evolutions.md, « Demandes ».

## Contraintes

- L'historique des interventions passées est conservé (demande-evolutions.md, « Demandes »).

## Hors périmètre

- Application mobile des techniciens : non concernée par ces évolutions (demande-evolutions.md, « Hors périmètre »).

## Hypothèses

- Hypothèse à valider : le PDF ne contient pas les photos de l'intervention (voir Q01).

## Questions au client

- Q01 (B01) : Le PDF doit-il inclure les photos prises par le technicien ?
  Réponse :
- Q02 (B03) : Que deviennent les interventions déjà planifiées d'un technicien désactivé ?
  Réponse :

## Points non déterminés

- Date de livraison souhaitée : non déterminée.
