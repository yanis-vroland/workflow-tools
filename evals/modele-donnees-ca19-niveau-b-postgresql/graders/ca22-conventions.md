---
type: llm
focus: { source: file, path: "docs/wf/modele-donnees/schema.sql" }
---

017-CA22 (conventions fixes de la spec). Dans `schema.sql` :

- les noms de tables et de colonnes sont en `snake_case` et en anglais ;
- chaque table a une clé primaire nommée `id` ;
- chaque clé étrangère est nommée `<table au singulier>_id` (ex. `site_id` vers la table des sites) et déclare sa référence (`REFERENCES`) ;
- chaque table a des colonnes `created_at` et `updated_at` ;
- chaque relation du modèle (client et sites, site et équipements, site et interventions, équipement et interventions, techniciens et interventions) est portée par une clé étrangère.

Échoue si l'une de ces conventions n'est pas respectée par une table, ou si une relation n'a pas de clé étrangère.
