---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/migration.sql" }
pattern: '^[ \t]*ALTER\s+TABLE\s+(IF\s+EXISTS\s+)?"?interventions"?[\s\S]*?DROP\s+(COLUMN\s+)?(IF\s+EXISTS\s+)?"?hourly_rate\b'
flags: im
match: contains
---

017-CA30 : la décision D01 confirmant la suppression étant saisie, la migration supprime la colonne `hourly_rate` (instruction active, pas en commentaire).
