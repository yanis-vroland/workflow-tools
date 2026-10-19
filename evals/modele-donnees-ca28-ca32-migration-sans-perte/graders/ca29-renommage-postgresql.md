---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/migration.sql" }
pattern: 'RENAME\s+COLUMN\s+"?report"?\s+TO\s+"?visit_report"?'
flags: i
match: contains
---

017-CA29 : la migration renomme la colonne `report` en `visit_report`.
