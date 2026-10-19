---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/migration.sql" }
pattern: 'RENAME\s+COLUMN\s+"?report"?\s+TO\s+"?visit_report"?'
flags: i
match: contains
---

017-CA29 : à la relance, le renommage de `report` reste un renommage.
