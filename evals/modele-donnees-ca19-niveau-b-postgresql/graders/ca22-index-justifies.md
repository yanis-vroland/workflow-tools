---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/schema.sql" }
pattern: '(^|\n)(?![ \t]*--[^\n]*Justification\s*:[^\n]*\b(R|RG)\d\d\b)[^\n]*\n[ \t]*CREATE\s+INDEX'
flags: i
match: not_contains
---

017-CA22 : chaque index (hors clé primaire et contrainte d'unicité) est précédé d'un commentaire « Justification : » qui cite une requête `Rnn` ou une règle `RGnn`.
