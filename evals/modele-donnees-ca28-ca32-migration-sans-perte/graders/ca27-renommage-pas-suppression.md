---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^### +Différences *$(?:(?!^#{1,6} )[\s\S])*?^[-*][^\n]*suppr[^\n]*`?(interventions\.)?report`?(?!\w)'
flags: mi
match: not_contains
---

017-CA27 et CA29 : le renommage de `report` n'est pas présenté comme une suppression.
