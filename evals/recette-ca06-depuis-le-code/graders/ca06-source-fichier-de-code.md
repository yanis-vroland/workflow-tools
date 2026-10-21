---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-\d{3}\s*\|(?:[^|\n]*\|){4}(?![^|\n]*(?:src/|mobile/lib/))[^|\n]*\|'
match: not_contains
---

CA6 : sans spec ni livrable wf-specs-tickets, la colonne Source de chaque cas
cite un fichier de code (sous `src/` ou `mobile/lib/`).
