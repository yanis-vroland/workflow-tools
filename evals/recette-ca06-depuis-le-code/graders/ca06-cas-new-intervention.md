---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-\d{3}\s*\|(?:[^|\n]*\|){4}[^|\n]*src/web/pages/NewIntervention\.tsx'
match: contains
---

CA6 : au moins un cas est déduit du formulaire de création d’une intervention, et sa colonne Source cite le
fichier de code `src/web/pages/NewIntervention.tsx`.
