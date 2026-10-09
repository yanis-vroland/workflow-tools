# Spec 002 : ordres de travail et facturation

Statut : validée
Date : 2025-11-03

## Besoin

En tant qu'administrateur, je veux regrouper les interventions d'une même demande client dans un ordre de travail et en calculer la facture, afin de facturer le client sans ressaisie.

## Critères d'acceptation

- CA1 : Étant donné un dispatcher ou un administrateur connecté, quand il crée un ordre de travail avec un client et une adresse, alors l'ordre apparaît dans la liste au statut « ouvert ».
- CA2 : Étant donné un ordre de travail et ses interventions, quand l'administrateur demande la facture, alors elle additionne main-d'œuvre et pièces, et applique une TVA de 20 %.
- CA3 : Étant donné une facture dont le sous-total est inférieur à 500 €, alors des frais de déplacement de 35 € sont ajoutés ; au-delà, le déplacement est offert.
- CA4 : Étant donné un client fidèle, alors une remise de 5 % est appliquée sur le sous-total.
- CA5 : Étant donné un technicien connecté, quand il demande la facture d'un ordre de travail, alors l'accès est refusé.
