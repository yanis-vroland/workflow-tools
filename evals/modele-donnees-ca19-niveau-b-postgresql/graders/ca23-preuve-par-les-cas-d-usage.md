---
type: llm
focus: trace
---

017-CA23. Les sources expriment au moins ces besoins : planification des interventions avec affectation selon la zone et les compétences, suivi de l'état de chaque intervention, saisie du compte rendu et envoi au client, historique des interventions par client et par équipement, tableau de bord mensuel, photos avant et après intervention.

En t'appuyant sur le contenu de `index.md` et de `requetes.sql` écrits par l'outil (appels Write visibles dans la trace) :

- la section « Preuve par les cas d'usage » de `index.md` reprend chacun de ces besoins, avec la requête de `requetes.sql` qui y répond (identifiant de requête) ;
- dans `requetes.sql`, chaque requête est précédée d'un commentaire qui la rattache à son besoin ;
- un besoin auquel aucune requête du schéma ne peut répondre (par exemple faute de table ou de colonne) est signalé comme un défaut du schéma dans « Revue du modèle ».

Échoue si un besoin manque à la preuve, si une requête n'est pas commentée et rattachée, ou si un besoin sans requête n'est pas signalé comme défaut.
