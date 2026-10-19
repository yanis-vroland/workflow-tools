# Cadrage du besoin : outil de gestion des interventions

- Outil : wf-cadrage-besoin
- Date : 2026-10-05
- Commit analysé : non déterminé (le projet n'est pas un dépôt git)
- Sources lues : brief-fieldops.md, notes-appel.md
- Derniers identifiants attribués : B06, Q04

## Synthèse

Une société de maintenance de chaudières et de pompes à chaleur souhaite un outil de planification et de suivi des interventions de ses techniciens, qui supprime la ressaisie des comptes rendus. La plateforme des techniciens a été tranchée (Q01) ; le volume reste à préciser (Q02).

## Contexte et objectifs

- 40 techniciens répartis sur deux agences, Nord et Sud ; planning tenu dans un tableur partagé (brief-fieldops.md, « Contexte »).

## Utilisateurs et rôles

- Dispatchers : planifient et affectent les interventions (brief-fieldops.md, « Contexte »).
- Techniciens : réalisent les interventions et rédigent les comptes rendus (brief-fieldops.md, « Fonctionnalités souhaitées »).
- Direction : consulte le tableau de bord mensuel (brief-fieldops.md, « Fonctionnalités souhaitées »).

## Besoins fonctionnels

- B01 : Planification des interventions par les dispatchers, avec affectation à un technicien selon sa zone et ses compétences. Priorité : indispensable. Source : brief-fieldops.md, « Fonctionnalités souhaitées ».
- B02 : Suivi de l'état de chaque intervention : planifiée, en cours, terminée. Priorité : indispensable. Source : brief-fieldops.md, « Fonctionnalités souhaitées ».
- B03 : Saisie du compte rendu par le technicien et envoi automatique au client par e-mail. Priorité : non précisée. Source : brief-fieldops.md, « Fonctionnalités souhaitées ».
- B04 : Historique des interventions par client et par équipement. Priorité : non précisée. Source : brief-fieldops.md, « Fonctionnalités souhaitées ».
- B05 : Tableau de bord mensuel pour la direction. Priorité : souhaitable. Source : brief-fieldops.md, « Fonctionnalités souhaitées ».
- B06 : Photos de l'installation avant et après intervention, prises par le technicien. Priorité : non précisée. Source : notes-appel.md, « Ce qui ressort de l'appel ».

## Contraintes

- Les données restent en France (brief-fieldops.md, « Contraintes »).
- Application mobile pour les techniciens, utilisable hors connexion ; navigateur sur PC pour les dispatchers (réponse saisie à la question Q01).

## Hors périmètre

- Facturation, gérée dans le logiciel comptable actuel (brief-fieldops.md, « Hors périmètre »).

## Hypothèses

Aucun élément.

## Questions au client

- Q01 : Le brief demande un outil web sans installation (brief-fieldops.md, « Contraintes »), les notes d'appel une application mobile hors connexion (notes-appel.md, « Ce qui ressort de l'appel ») : quelle plateforme pour les techniciens ?
  Réponse : Application mobile pour les techniciens, utilisable hors connexion ; navigateur sur PC pour les dispatchers.
- Q02 (B01) : « Nous traitons beaucoup d'interventions » (brief-fieldops.md, « Contexte ») : combien d'interventions par mois, en moyenne et en pointe ?
  Réponse :
- Q03 (B05) : quels indicateurs doit contenir le tableau de bord mensuel ?
  Réponse :
- Q04 : faut-il reprendre l'historique du tableur (notes-appel.md, « À clarifier ») ?
  Réponse :

## Points non déterminés

- Hébergement, date de mise en production précise, budget : non déterminé.
