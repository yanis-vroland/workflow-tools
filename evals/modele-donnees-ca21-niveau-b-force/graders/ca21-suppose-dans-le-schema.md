---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/schema.sql" }
pattern: '--[^\n]*supposé[^\n]*Q03|--[^\n]*Q03[^\n]*supposé'
flags: i
match: contains
---

017-CA21 : dans le schéma, un commentaire marque « supposé » l'élément qui dépend de la question vide Q03.
