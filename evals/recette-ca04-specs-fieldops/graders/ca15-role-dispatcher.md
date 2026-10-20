---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n##? [^\n]*Pr[ée]requis(?:(?!\n##? )[\s\S])*\bdispatcher\b'
match: contains
---

CA15 : « Prérequis » liste le rôle dispatcher.
