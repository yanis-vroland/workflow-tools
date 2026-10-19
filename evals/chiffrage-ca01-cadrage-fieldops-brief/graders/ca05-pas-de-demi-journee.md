---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^\| *C\d{2} *\|(?:[^|\n]*\|){2}(?:[^|\n]*\|)? *\d+[,.](?!(?:0+|50*)(?!\d))\d'
flags: m
match: not_contains
---

005-CA5 : aucune estimation basse ou haute d'une tâche n'a une partie décimale autre que ,0 ou ,5 (zéros finaux admis : 1,50) ; pas de 0,5 jour.
