---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/migration.sql" }
pattern: '(postgres(ql)?|mysql|sqlite|mongodb)://'
flags: i
match: not_contains
---

017-CA38 : aucune chaîne de connexion à une base n'est recopiée dans la migration.
