---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-\d{3}\s*\|(?:[^|\n]*\|){4}(?![^|\n]*spec brouillon)[^|\n]*003-export-pdf|\n\|\s*REC-\d{3}\s*\|(?:[^|\n]*\|){4}[^|\n]*00[12]-[^|\n]*spec brouillon'
match: not_contains
---

CA13 : chaque cas tiré de la spec 003 porte « spec brouillon » dans sa Source,
et aucun cas tiré des specs validées (001, 002) ne la porte.
