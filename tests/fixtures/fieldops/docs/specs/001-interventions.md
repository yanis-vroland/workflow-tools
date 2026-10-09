# Spec 001 : suivi des interventions

Statut : validée
Date : 2025-09-15

## Besoin

En tant que dispatcher, je veux planifier les interventions des techniciens et suivre leur avancement, afin de savoir à tout moment ce qui est fait, en cours ou à venir.

## Critères d'acceptation

- CA1 : Étant donné un dispatcher connecté, quand il crée une intervention avec un ordre de travail, une adresse et une date de début, alors elle apparaît dans la liste au statut « Planifiée ».
- CA2 : Étant donné une intervention sans ordre de travail ou sans date de début, quand le dispatcher la valide, alors la création est refusée avec un message d'erreur.
- CA3 : Étant donné la liste des interventions, quand l'utilisateur filtre par statut, alors seules les interventions de ce statut sont affichées.
- CA4 : Étant donné une intervention planifiée, quand le technicien la démarre depuis l'application mobile, alors son statut passe à « En cours ».
- CA5 : Étant donné une intervention terminée, quand on tente de la repasser « En cours », alors le changement est refusé.
- CA6 : Étant donné une intervention clôturée avec un compte rendu, alors le client reçoit le compte rendu par e-mail.
