# Brief : outil de gestion des interventions

Société Démo Thermique (société fictive) — maintenance de chaudières et de pompes à chaleur
Contact projet : Sophie Renaud, responsable d'exploitation — projet.sdt@example.invalid
Date : 15 septembre 2026

## Contexte

Nous employons 40 techniciens répartis sur deux agences (Nord et Sud). Le planning est
aujourd'hui tenu dans un tableur partagé par les deux dispatchers, et les comptes rendus
d'intervention sont rédigés sur papier puis ressaisis au bureau. Nous traitons beaucoup
d'interventions, surtout en période de chauffe, et les erreurs de planning se multiplient.

## Objectifs

- Supprimer la ressaisie des comptes rendus.
- Donner aux dispatchers une vue claire du planning de chaque technicien.
- Informer le client à la fin de chaque intervention.

## Fonctionnalités souhaitées

1. Planification des interventions par les dispatchers, avec affectation à un technicien
   selon sa zone et ses compétences (indispensable).
2. Suivi de l'état de chaque intervention : planifiée, en cours, terminée (indispensable).
3. Saisie du compte rendu par le technicien et envoi automatique au client par e-mail.
4. Historique des interventions par client et par équipement.
5. Tableau de bord mensuel pour la direction (souhaitable).

## Contraintes

- Il s'agit d'un **outil web**, utilisé depuis un navigateur ; aucune installation sur les
  postes ni sur les téléphones.
- L'outil doit être rapide, même en fin de mois.
- L'interface doit être intuitive : nos techniciens ne sont pas à l'aise avec l'informatique.
- Les données restent en France.

## Hors périmètre

La facturation n'est pas concernée : elle reste gérée dans notre logiciel comptable actuel.

## Délai

Nous souhaitons un outil opérationnel avant la prochaine saison de chauffe.
