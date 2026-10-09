# Spec 003 : export PDF des interventions

Statut : brouillon
Date : 2026-09-22

## Besoin

En tant que dispatcher, je veux exporter en PDF le compte rendu d'une intervention terminée, afin de l'envoyer au client ou de l'archiver.

## Critères d'acceptation

- CA1 : Étant donné une intervention terminée, quand le dispatcher clique sur « Exporter en PDF », alors un PDF est téléchargé avec l'adresse, le technicien, les horaires et le compte rendu.
- CA2 : Étant donné une intervention qui n'est pas terminée, alors le bouton « Exporter en PDF » n'est pas proposé.
- CA3 : Étant donné un PDF exporté, alors il porte le logo FieldOps et la date d'export.

Question ouverte : faut-il inclure les photos prises par le technicien ?
