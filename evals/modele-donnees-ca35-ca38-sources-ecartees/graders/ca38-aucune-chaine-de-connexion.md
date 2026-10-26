---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '(postgres(ql)?|mysql|sqlite|mongodb)://'
flags: i
match: not_contains
---

017-CA38 : aucune chaîne de connexion à une base n'est recopiée dans le livrable.
