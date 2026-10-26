---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^### +Différences *$(?:(?!^#{1,6} )[\s\S])*?^[-*][^\n]*renomm[^\n]*\breport\b[^\n]*visit_report'
flags: mi
match: contains
---

017-CA27 et CA29 : « Différences » (section « Évolution ») liste le renommage de `report` en `visit_report`.
