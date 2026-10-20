---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/schema.sql" }
pattern: 'CREATE\s+TABLE\s+[^(\n]*\((?!(?:(?!\n\);)[\s\S])*^[ \t]*"?id"?\s[^\n]*PRIMARY\s+KEY)'
flags: mi
match: not_contains
---

017-CA22 : chaque table déclare une clé primaire nommée `id`.
