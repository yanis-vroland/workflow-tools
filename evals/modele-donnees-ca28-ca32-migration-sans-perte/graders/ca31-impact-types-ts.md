---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?Évolution *$(?:(?!^## )[\s\S])*?src/domain/types\.ts[^\n]*\breport\b'
flags: m
match: contains
---

017-CA31 : « Évolution » liste `src/domain/types.ts` (champ `report` du type), touché par le renommage de `report`, avec l'élément utilisé sur la même ligne.
