---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?Évolution *$(?:(?!^## )[\s\S])*?src/api/routes/interventions\.ts[^\n]*\breport\b'
flags: m
match: contains
---

017-CA31 : « Évolution » liste `src/api/routes/interventions.ts` (requête `UPDATE … report = …`), touché par le renommage de `report`, avec l'élément utilisé sur la même ligne.
