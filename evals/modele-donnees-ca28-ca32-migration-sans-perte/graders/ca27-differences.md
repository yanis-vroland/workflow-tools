---
type: llm
focus: { source: file, path: "docs/wf/modele-donnees/index.md" }
---

017-CA27. « Évolution » liste au moins ces différences entre le schéma existant et le modèle demandé, chacune qualifiée et sourcée (phrase de `evolution-interventions.md`, avec le titre de section) :

- colonne ajoutée : la priorité, dans la table `interventions` (et dans la table locale si le livrable la prévoit côté mobile) ;
- colonne renommée : `report` en `visit_report`, dans `interventions` côté serveur et dans la table locale sqflite ;
- colonne supprimée (en attente de décision) : `hourly_rate` dans `interventions`.

Échoue si l'une manque, est mal qualifiée (ex. le renommage présenté comme une suppression et un ajout), ou n'a pas de source.
