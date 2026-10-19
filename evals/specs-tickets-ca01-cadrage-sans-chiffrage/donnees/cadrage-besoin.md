# Cadrage du besoin : outil de gestion des interventions

- Outil : wf-cadrage-besoin
- Date : 2026-10-14
- Commit analysé : non déterminé (le projet n'est pas un dépôt git)
- Sources lues : brief-fieldops.md, notes-appel.md
- Derniers identifiants attribués : B07, Q07

## Synthèse

Société Démo Thermique souhaite un outil de planification et de suivi des interventions de ses 40 techniciens, qui supprime la ressaisie des comptes rendus et informe le client en fin d'intervention. Les techniciens utiliseront une application mobile Android hors connexion, les dispatchers un navigateur (Q03). Le volume d'interventions (Q01), le temps d'affichage attendu (Q02), le critère d'ergonomie (Q04), l'hébergement (Q05) et la reprise de l'historique (Q06) restent ouverts.

## Contexte et objectifs

- Planning tenu dans un tableur partagé par deux dispatchers ; comptes rendus papier ressaisis au bureau (brief-fieldops.md, « Contexte »).
- Objectifs : supprimer la ressaisie, donner une vue claire du planning, informer le client en fin d'intervention (brief-fieldops.md, « Objectifs »).

## Utilisateurs et rôles

- Dispatchers : planifient et affectent les interventions (brief-fieldops.md, « Contexte »).
- Techniciens : réalisent les interventions et rédigent les comptes rendus (brief-fieldops.md, « Fonctionnalités souhaitées »).
- Direction : consulte le tableau de bord mensuel (brief-fieldops.md, « Fonctionnalités souhaitées »).

## Besoins fonctionnels

- B01 : Planification des interventions par les dispatchers, avec affectation à un technicien selon sa zone et ses compétences. Priorité : indispensable. Source : brief-fieldops.md, « Fonctionnalités souhaitées ».
- B02 : Suivi de l'état de chaque intervention : planifiée, en cours, terminée. Priorité : indispensable. Source : brief-fieldops.md, « Fonctionnalités souhaitées ».
- B03 : Saisie du compte rendu d'intervention par le technicien sur une application mobile utilisable hors connexion. Priorité : non précisée. Source : brief-fieldops.md, « Fonctionnalités souhaitées » ; réponse saisie à la question Q03.
- B04 : Envoi automatique du compte rendu au client par e-mail à la fin de l'intervention. Priorité : non précisée. Source : brief-fieldops.md, « Fonctionnalités souhaitées ».
- B05 : Historique des interventions par client et par équipement. Priorité : non précisée. Source : brief-fieldops.md, « Fonctionnalités souhaitées ».
- B06 : Tableau de bord mensuel pour la direction. Priorité : souhaitable. Source : brief-fieldops.md, « Fonctionnalités souhaitées ».
- B07 : Prise de photos de l'installation avant et après intervention par le technicien. Priorité : non précisée. Source : notes-appel.md, « Ce qui ressort de l'appel ».

## Contraintes

- Les données restent en France (brief-fieldops.md, « Contraintes »).
- Application mobile Android pour les techniciens, utilisable hors connexion ; navigateur sur PC pour les dispatchers (réponse saisie à la question Q03).

## Hors périmètre

- Facturation, gérée dans le logiciel comptable actuel (brief-fieldops.md, « Hors périmètre » ; notes-appel.md, « Ce qui ressort de l'appel »).

## Hypothèses

- Hypothèse à valider : l'historique du tableur actuel n'est pas repris dans le nouvel outil (voir Q06).

## Questions au client

- Q01 (B01, B06) : « Nous traitons beaucoup d'interventions » (brief-fieldops.md, « Contexte ») : combien d'interventions par mois, en moyenne et en pointe ?
  Réponse :
- Q02 (B01) : « L'outil doit être rapide, même en fin de mois » (brief-fieldops.md, « Contraintes ») : quel temps d'affichage maximal du planning est attendu, et pour combien d'interventions affichées ?
  Réponse :
- Q03 (B03) : Le brief demande un outil web sans installation sur les téléphones (brief-fieldops.md, « Contraintes »), les notes d'appel une application mobile installée et utilisable hors connexion (notes-appel.md, « Ce qui ressort de l'appel ») : quelle plateforme pour les techniciens ?
  Réponse : Application mobile Android pour les techniciens, utilisable hors connexion ; les dispatchers utilisent un navigateur sur PC.
- Q04 (B03) : « L'interface doit être intuitive : nos techniciens ne sont pas à l'aise avec l'informatique » (brief-fieldops.md, « Contraintes ») : quel critère vérifiable retenir (nombre d'écrans pour saisir un compte rendu, durée de prise en main) ?
  Réponse :
- Q05 : Où et par qui l'outil doit-il être hébergé, sachant que les données restent en France ?
  Réponse :
- Q06 (B05) : « Faut-il reprendre l'historique du tableur ? » (notes-appel.md, « À clarifier ») : l'historique actuel doit-il être importé, et sur quelle profondeur ?
  Réponse :
- Q07 (B04) : Quel contenu doit avoir l'e-mail envoyé au client à la fin de l'intervention ?
  Réponse : Le compte rendu en pièce jointe, avec le logo de la société et le nom du technicien.

## Points non déterminés

- Date de mise en production précise : non déterminée (« avant la prochaine saison de chauffe », brief-fieldops.md, « Délai »).
- Budget : non déterminé (notes-appel.md, « Ce qui ressort de l'appel »).
