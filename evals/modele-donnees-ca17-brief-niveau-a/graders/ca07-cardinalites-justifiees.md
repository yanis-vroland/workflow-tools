---
type: llm
focus: { source: file, path: "docs/wf/modele-donnees/index.md" }
---

017-CA7. Dans le livrable :

- chaque règle de « Règles de gestion » a un identifiant unique de la forme `RGnn` (`RG01`, `RG02`…), aucun en double, et une source (phrase citée avec fichier et section) ou la marque « supposé » ;
- chaque cardinalité du modèle (diagramme ou relations) découle d'une règle `RGnn` citée, ou est marquée « supposé ».

Échoue si une règle n'a pas d'identifiant ou de source, si deux règles partagent un identifiant, ou si une cardinalité n'est ni rattachée à une règle ni marquée « supposé ».
