---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?Évolution *$(?:(?!^## )[\s\S])*?mobile/lib/db/local_db\.dart[^\n]*\breport\b'
flags: m
match: contains
---

017-CA31 : « Évolution » liste `mobile/lib/db/local_db.dart` (table locale avec `report`), touché par le renommage de `report`, avec l'élément utilisé sur la même ligne.
