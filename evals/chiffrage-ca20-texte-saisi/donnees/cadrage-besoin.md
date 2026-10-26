# Cadrage du besoin : outil de gestion des interventions

- Outil : wf-cadrage-besoin
- Date : 2026-10-14
- Commit analysé : non déterminé (le projet n'est pas un dépôt git)
- Sources lues : brief-fieldops.md, notes-appel.md, echange-direction.md
- Derniers identifiants attribués : B07, Q06

## Synthèse

Société Démo Thermique souhaite un outil de planification et de suivi des interventions de ses 40 techniciens, qui supprime la ressaisie des comptes rendus papier. Le client a tranché la plateforme (Q02) et l'hébergement (Q04). Restent ouverts le volume d'interventions (Q01), la reprise de l'historique du tableur (Q03) et le contenu de l'assistant demandé par la direction (Q06).

## Contexte et objectifs

- Planning tenu dans un tableur partagé par deux dispatchers ; comptes rendus papier ressaisis au bureau (brief-fieldops.md, « Contexte »).
- Objectifs : supprimer la ressaisie, donner une vue claire du planning, informer le client en fin d'intervention (brief-fieldops.md, « Objectifs »).

## Utilisateurs et rôles

- Dispatchers : planifient et affectent les interventions, depuis un navigateur sur PC (brief-fieldops.md, « Contexte » ; notes-appel.md, « Ce qui ressort de l'appel »).
- Techniciens : réalisent les interventions et rédigent les comptes rendus (brief-fieldops.md, « Fonctionnalités souhaitées »).
- Direction : consulte le tableau de bord mensuel (brief-fieldops.md, « Fonctionnalités souhaitées »).

## Besoins fonctionnels

- B01 : Planification des interventions par les dispatchers, avec affectation à un technicien selon sa zone et ses compétences. Priorité : indispensable. Source : brief-fieldops.md, « Fonctionnalités souhaitées ».
- B02 : Suivi de l'état de chaque intervention (planifiée, en cours, terminée). Priorité : indispensable. Source : brief-fieldops.md, « Fonctionnalités souhaitées ».
- B03 : Saisie du compte rendu par le technicien sur l'application mobile, y compris hors connexion, et envoi automatique au client par e-mail. Priorité : non précisée. Source : brief-fieldops.md, « Fonctionnalités souhaitées » ; réponse saisie à la question Q02.
- B04 : Historique des interventions par client et par équipement. Priorité : non précisée. Source : brief-fieldops.md, « Fonctionnalités souhaitées ».
- B05 : Tableau de bord mensuel pour la direction. Priorité : souhaitable. Source : brief-fieldops.md, « Fonctionnalités souhaitées ».
- B06 : Prise de photos de l'installation avant et après intervention, depuis l'application mobile. Priorité : non précisée. Source : notes-appel.md, « Ce qui ressort de l'appel ».
- B07 : Un assistant « intelligent » pour aider les dispatchers, dont le rôle n'est pas décrit. Priorité : non précisée. Source : echange-direction.md, « Demandes de la direction ».

## Contraintes

- Les données restent en France (brief-fieldops.md, « Contraintes »).
- Application mobile Android et iOS pour les techniciens, utilisable hors connexion ; back-office web pour les dispatchers (réponse saisie à la question Q02).
- Hébergement chez un hébergeur situé en France, choisi et mis en place par le prestataire (réponse saisie à la question Q04).

## Hors périmètre

- Facturation, gérée dans le logiciel comptable actuel (brief-fieldops.md, « Hors périmètre » ; notes-appel.md, « Ce qui ressort de l'appel »).

## Hypothèses

- Hypothèse à valider : le volume d'interventions reste de l'ordre de quelques centaines par mois (voir Q01).
- Hypothèse à valider : l'historique du tableur n'est pas repris (voir Q03).

## Questions au client

- Q01 (B01, B05) : « Nous traitons beaucoup d'interventions » (brief-fieldops.md, « Contexte ») : combien d'interventions par mois, en moyenne et en pointe ?
  Réponse :
- Q02 (B03, B06) : Le brief demande un outil web sans installation sur les téléphones (brief-fieldops.md, « Contraintes »), les notes d'appel une application mobile installée et utilisable hors connexion (notes-appel.md, « Ce qui ressort de l'appel ») : quelle plateforme pour les techniciens ?
  Réponse : Application mobile Android et iOS pour les techniciens, publiée sur les stores et utilisable hors connexion ; back-office web pour les dispatchers.
- Q03 (B04) : Faut-il reprendre l'historique des interventions tenu dans le tableur actuel (notes-appel.md, « À clarifier ») ?
  Réponse :
- Q04 : Où et par qui l'outil doit-il être hébergé, sachant que les données restent en France ?
  Réponse : Chez un hébergeur situé en France, choisi et mis en place par le prestataire.
- Q05 : Quel budget est envisagé pour ce projet ?
  Réponse : Budget indicatif de 25 000 € HT, soit environ 50 jours à 500 € par jour.
- Q06 (B07) : « Il faudrait un assistant intelligent pour aider les dispatchers » (echange-direction.md, « Demandes de la direction ») : quelles tâches précises cet assistant doit-il accomplir ?
  Réponse :

## Points non déterminés

- Date de mise en production précise : non déterminé (seulement « avant la prochaine saison de chauffe », brief-fieldops.md, « Délai »).
