---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?Revue du modèle *$(?:(?!^## )[\s\S])*?^### +Éléments supposés *$(?:(?!^## )[\s\S])*?^### +Nommage incohérent *$'
flags: m
match: contains
---

017-CA14 : « Revue du modèle » contient les sous-sections « Éléments supposés » et « Nommage incohérent ».
