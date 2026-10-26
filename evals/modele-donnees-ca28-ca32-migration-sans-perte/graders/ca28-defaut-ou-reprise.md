---
type: llm
focus: { source: file, path: "docs/wf/modele-donnees/migration.sql" }
---

017-CA28. La demande ajoute une priorité obligatoire (« normale » ou « urgente ») à la table existante des interventions, dont les lignes déjà enregistrées sont toutes de priorité normale.

Dans `migration.sql`, la colonne de priorité est ajoutée de façon sans perte, selon l'une de ces deux voies :

- avec une valeur par défaut correspondant à « normale » dans la même instruction que `NOT NULL` ;
- ou ajoutée sans contrainte, remplie par une reprise (`UPDATE … SET … = 'normal'` ou équivalent) des lignes existantes, puis rendue obligatoire (`ALTER COLUMN … SET NOT NULL`) après ce remplissage.

Jamais une contrainte `NOT NULL` seule, sans valeur par défaut ni reprise préalable. Échoue sinon.
