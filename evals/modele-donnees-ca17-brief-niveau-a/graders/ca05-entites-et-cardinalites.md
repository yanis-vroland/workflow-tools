---
type: llm
focus: { source: file, path: "docs/wf/modele-donnees/index.md" }
---

017-CA5. Le bloc Mermaid `erDiagram` de « Modèle conceptuel » :

- reprend toutes les entités décrites dans le livrable (dictionnaire de données, règles de gestion), aucune ne manque ;
- reprend toutes les relations décrites dans le livrable ;
- donne pour chaque relation une cardinalité en notation Mermaid (ex. `||--o{`, `}o--o{`), à chaque extrémité ;
- est syntaxiquement plausible (lignes `A ||--o{ B : libellé`, blocs d'attributs entre accolades).

Échoue si une entité ou une relation du livrable manque au diagramme, ou si une relation n'a pas de cardinalité.
