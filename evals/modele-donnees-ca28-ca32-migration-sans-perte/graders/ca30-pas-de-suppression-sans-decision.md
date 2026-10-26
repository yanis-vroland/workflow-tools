---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/migration.sql" }
pattern: 'DROP\s+(COLUMN\s+)?(IF\s+EXISTS\s+)?"?hourly_rate\b'
flags: i
match: not_contains
---

017-CA30 : sans décision saisie qui la confirme, la suppression de `hourly_rate` n'est pas écrite dans la migration, même en commentaire.
