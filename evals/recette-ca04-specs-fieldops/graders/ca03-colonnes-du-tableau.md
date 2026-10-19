---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*ID\s*\|\s*Fonctionnalit[ée]\s*\|\s*Pr[ée]conditions\s*\|\s*[ÉE]tapes\s*\|\s*R[ée]sultat attendu\s*\|\s*Source\s*\|\s*Statut\s*\|\s*Commentaire\s*\|\s*\n'
match: contains
---

CA3 : « Cas de recette » est un tableau Markdown aux huit colonnes de la spec, dans l'ordre.
