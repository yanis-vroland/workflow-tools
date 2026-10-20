---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/schema.sql" }
pattern: 'CREATE\s+TABLE\s+"?\w*[A-Z]|^[ \t]+(?!CONSTRAINT|PRIMARY|FOREIGN|UNIQUE|CHECK)"?[a-z0-9_]*[A-Z][A-Za-z0-9_]*"?\s+[A-Za-z]'
flags: m
match: not_contains
---

017-CA22 : noms de tables et de colonnes en `snake_case` (aucune majuscule).
