---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^\|(?!\s*:?-)(?=(?:[^|\n]*\|){6}[ \t]*$)(?:[^|\n]*\|){0,5}[ \t]*\|'
flags: m
match: not_contains
---

017-CA6 : chaque ligne du dictionnaire (six colonnes) est complète : aucune cellule vide (type, obligatoire, exemple, source…).
