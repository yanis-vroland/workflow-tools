# Cadrage du besoin : outil de gestion des interventions

- Outil : wf-cadrage-besoin
- Date : 2026-10-15
- Commit analysé : non déterminé (le projet n'est pas un dépôt git)
- Sources lues : brief-fieldops.md, notes-appel.md, reponse-client.md
- Derniers identifiants attribués : B06, Q04

## Synthèse

Société Démo Thermique souhaite un back-office web de planification et de suivi des interventions. Après échange, la saisie mobile des comptes rendus est reportée à une phase ultérieure (Q03) ; le tableau de bord mensuel doit pouvoir être exporté, et un rappel par SMS au client est ajouté.

## Contexte et objectifs

- Planning tenu dans un tableur partagé par deux dispatchers (brief-fieldops.md, « Contexte »).

## Utilisateurs et rôles

- Dispatchers : planifient et affectent les interventions, depuis un navigateur sur PC (brief-fieldops.md, « Contexte »).
- Direction : consulte le tableau de bord mensuel (brief-fieldops.md, « Fonctionnalités souhaitées »).

## Besoins fonctionnels

- B01 : Planification des interventions par les dispatchers, avec affectation à un technicien selon sa zone et ses compétences. Priorité : indispensable. Source : brief-fieldops.md, « Fonctionnalités souhaitées ».
- B02 : Suivi de l'état de chaque intervention (planifiée, en cours, terminée). Priorité : indispensable. Source : brief-fieldops.md, « Fonctionnalités souhaitées ».
- B04 : Historique des interventions par client et par équipement. Priorité : non précisée. Source : brief-fieldops.md, « Fonctionnalités souhaitées ».
- B05 : Tableau de bord mensuel pour la direction, exportable au format tableur. Priorité : souhaitable. Source : brief-fieldops.md, « Fonctionnalités souhaitées » ; reponse-client.md.
- B06 : Rappel par SMS au client la veille de l'intervention. Priorité : important. Source : reponse-client.md.

## Contraintes

- Les données restent en France (brief-fieldops.md, « Contraintes »).
- Back-office web uniquement pour cette phase (réponse saisie à la question Q03).

## Hors périmètre

- Facturation (brief-fieldops.md, « Hors périmètre »).
- Saisie des comptes rendus sur mobile, reportée à une phase ultérieure (réponse saisie à la question Q03).

## Hypothèses

- Hypothèse à valider : le volume reste de quelques centaines d'interventions par mois (voir Q01).

## Questions au client

- Q01 (B01) : « Nous traitons beaucoup d'interventions » (brief-fieldops.md, « Contexte ») : combien d'interventions par mois ?
  Réponse :
- Q03 : Quelle plateforme pour les techniciens ?
  Réponse : Aucune pour cette phase : seul le back-office web est réalisé, la saisie mobile est reportée.
- Q04 (B06) : Quel prestataire d'envoi de SMS utiliser ?
  Réponse :

## Points non déterminés

- Aucun.
