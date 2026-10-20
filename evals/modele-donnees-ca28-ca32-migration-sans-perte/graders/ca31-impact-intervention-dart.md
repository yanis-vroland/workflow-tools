---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?Évolution *$(?:(?!^## )[\s\S])*?mobile/lib/models/intervention\.dart[^\n]*\breport\b'
flags: m
match: contains
---

017-CA31 : « Évolution » liste `mobile/lib/models/intervention.dart` (champ `report` du modèle), touché par le renommage de `report`, avec l'élément utilisé sur la même ligne.
