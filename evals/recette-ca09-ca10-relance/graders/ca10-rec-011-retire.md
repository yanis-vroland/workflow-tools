---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '###? [^\n]*Cas retir[ée]s(?:(?!\n##? |\n### )[\s\S])*REC-011[^\n]*bloqu[ée]'
match: contains
---

CA10 : REC-011, dont le critère source (002#CA7) n'existe plus, est listé sous
« Cas retirés » avec son dernier statut « bloqué ».
