---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '###? [^\n]*Cas retir[ée]s(?:(?!\n##? |\n### )[\s\S])*REC-010[^\n]*non conforme'
match: contains
---

CA10 : REC-010, dont la spec source (005-notifications-sms) a disparu, est
listé sous « Cas retirés » avec son dernier statut « non conforme ».
