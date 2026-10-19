---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/migration.sql" }
pattern: 'DROP\s+COLUMN\s+(IF\s+EXISTS\s+)?"?report"?\b'
flags: i
match: not_contains
---

017-CA29 : la colonne renommée n'est pas supprimée pour être recréée.
