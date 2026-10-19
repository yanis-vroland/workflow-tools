---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-\d{3}\s*\|(?:[^|\n]*\|){4}[^|\n]*src/api/routes/technicians\.ts'
match: contains
---

CA6 : au moins un cas est déduit de la route des techniciens, et sa colonne Source cite le
fichier de code `src/api/routes/technicians.ts`.
