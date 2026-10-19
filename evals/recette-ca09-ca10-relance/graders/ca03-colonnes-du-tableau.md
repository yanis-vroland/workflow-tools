---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '^(?![\s\S]*2026-09-15)[\s\S]*?(?:\n\|\s*ID\s*\|\s*Fonctionnalit[ée]\s*\|\s*Pr[ée]conditions\s*\|\s*[ÉE]tapes\s*\|\s*R[ée]sultat attendu\s*\|\s*Source\s*\|\s*Statut\s*\|\s*Commentaire\s*\|\s*\n)'
match: contains
---

CA3 : « Cas de recette » est un tableau Markdown aux huit colonnes de la spec, dans l'ordre.

Discriminant : échoue tant que le cahier déposé par le scaffold (daté du 2026-09-15) n'a pas été réécrit.
