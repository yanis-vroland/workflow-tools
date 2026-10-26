---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '(?<!«[^»\n]*)(?<![\p{L}\p{N}_-])(?:scheduling|dispatchers?|dashboards?|technicians?|jobs?|job reports?|invoicing|requirements|background|out of scope|constraints|customers?|spreadsheets?|boilers?|monthly)(?![\p{L}\p{N}_-])(?![^«\n]*»)'
flags: iu
match: not_contains
---

004-CA20 : complète le correcteur des mots-outils, qui laisse passer un titre, un rôle ou un libellé recopié de la source anglaise sans mot-outil (« Field service scheduling tool », « Dispatcher », « Monthly dashboard »). Aucun terme propre au brief `brief-en.md` n'apparaît hors d'une citation entre « » : titre, rôles et libellés sont traduits, les titres de section de la source ne figurent qu'entre « ».
