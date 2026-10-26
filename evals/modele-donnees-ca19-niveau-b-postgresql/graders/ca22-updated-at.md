---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/schema.sql" }
pattern: 'CREATE\s+TABLE\s+[^(\n]*\((?!(?:(?!\n\);)[\s\S])*^[ \t]*"?updated_at"?\s)'
flags: mi
match: not_contains
---

017-CA22 : chaque table a une colonne `updated_at`.
