---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/schema.sql" }
pattern: '^[ \t]+"?(\w+_id)"?\s(?![^\n]*REFERENCES)(?![\s\S]*FOREIGN\s+KEY\s*\([^)]*\b\1\b)(?<!FOREIGN\s+KEY\s*\([^)]*\b\1\b[\s\S]*)'
flags: mi
match: not_contains
---

017-CA22 : chaque colonne `<table au singulier>_id` est une clé étrangère déclarée (`REFERENCES` sur sa ligne ou clause `FOREIGN KEY`).
