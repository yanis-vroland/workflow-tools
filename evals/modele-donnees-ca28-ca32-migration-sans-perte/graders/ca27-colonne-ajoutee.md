---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^### +Différences *$(?:(?!^#{1,6} )[\s\S])*?^[-*][^\n]*ajout[^\n]*priorit'
flags: mi
match: contains
---

017-CA27 : « Différences » (section « Évolution ») liste l'ajout de la colonne de priorité.
