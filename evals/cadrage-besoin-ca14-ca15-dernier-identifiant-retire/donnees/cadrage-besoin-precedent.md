# Cadrage du besoin : outil de gestion des interventions

- Outil : wf-cadrage-besoin
- Date : 2026-09-25
- Commit analysé : non déterminé (le projet n'est pas un dépôt git)
- Sources lues : brief-fieldops.md, notes-appel.md, ancien-brief.md (introuvable)
- Derniers identifiants attribués : B06, Q06

## Synthèse

Société Démo Thermique souhaite un outil de planification et de suivi des interventions de ses 40 techniciens, qui supprime la ressaisie des comptes rendus. La plateforme cible reste à clarifier (Q02).

## Contexte et objectifs

- Planning tenu dans un tableur partagé par deux dispatchers ; comptes rendus papier ressaisis au bureau (brief-fieldops.md, « Contexte »).

## Utilisateurs et rôles

- Dispatchers : planifient et affectent les interventions (brief-fieldops.md, « Contexte »).
- Techniciens : réalisent les interventions et rédigent les comptes rendus (brief-fieldops.md, « Fonctionnalités souhaitées »).

## Besoins fonctionnels

- B01 : Planification des interventions avec affectation selon la zone et les compétences. Priorité : indispensable. Source : brief-fieldops.md, « Fonctionnalités souhaitées ».
- B02 : Suivi de l'état de chaque intervention (planifiée, en cours, terminée). Priorité : indispensable. Source : brief-fieldops.md, « Fonctionnalités souhaitées ».
- B03 : Saisie du compte rendu par le technicien et envoi automatique au client. Priorité : non précisée. Source : brief-fieldops.md, « Fonctionnalités souhaitées ».
- B04 : Tableau de bord mensuel pour la direction. Priorité : souhaitable. Source : brief-fieldops.md, « Fonctionnalités souhaitées ».

## Contraintes

- Les données restent en France (brief-fieldops.md, « Contraintes »).
- Plateforme cible : non déterminée, voir Q02.

## Hors périmètre

- Facturation, gérée dans le logiciel comptable actuel (brief-fieldops.md, « Hors périmètre »).

## Hypothèses

Aucun élément.

## Questions au client

- Q01 (B01, B04) : « Nous traitons beaucoup d'interventions » (brief-fieldops.md, « Contexte ») : combien d'interventions par mois, en moyenne et en pointe ?
  Réponse :
- Q02 : Le brief demande un outil web sans installation sur les téléphones (brief-fieldops.md, « Contraintes »), les notes d'appel une application mobile installée et utilisable hors connexion (notes-appel.md, « Ce qui ressort de l'appel ») : quelle plateforme pour les techniciens ?
  Réponse :
- Q03 : « L'outil doit être rapide, même en fin de mois » (brief-fieldops.md, « Contraintes ») : quel temps d'affichage maximal attendu pour le planning ?
  Réponse :
- Q04 : Où et par qui l'outil doit-il être hébergé, sachant que les données restent en France ?
  Réponse :

## Points non déterminés

- ancien-brief.md : source introuvable, à repasser en argument si elle est retrouvée : non déterminé.
- Date de mise en production précise : non déterminée.
