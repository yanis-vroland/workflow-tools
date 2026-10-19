# Demande d'évolution : interventions

Société fictive de maintenance — demande transmise par la responsable d'exploitation.

## Changements demandés

- Chaque intervention doit désormais avoir une priorité obligatoire : « normale » ou « urgente ». Les interventions déjà enregistrées sont toutes de priorité normale.
- Le compte rendu d'intervention, aujourd'hui enregistré dans le champ `report`, s'appellera `visit_report`, sur le serveur comme dans l'application mobile. Les comptes rendus déjà saisis doivent être conservés.
- Le taux horaire des interventions (`hourly_rate`) ne nous sert plus : la facturation est sortie de l'outil.

## Contraintes

- Aucune donnée existante ne doit être perdue lors de la mise à jour.
- L'application mobile est déjà installée sur les téléphones des techniciens : la mise à jour doit reprendre leur base locale existante.
