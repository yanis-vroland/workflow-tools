---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^### +Différences *$(?:(?!^#{1,6} )[\s\S])*?^[-*][^\n]*suppr[^\n]*hourly_rate[^\n]*(attente|D\d\d)'
flags: mi
match: contains
---

017-CA27 et CA30 : « Différences » (section « Évolution ») liste la suppression de `hourly_rate`, en attente de sa décision.
