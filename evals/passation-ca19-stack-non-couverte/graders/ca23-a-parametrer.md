---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Points d.attention[^\n]*\n(?:(?!\n##? )[\s\S])*?à paramétrer au redéploiement'
match: contains
---

CA23 : l'adresse est signalée « à paramétrer au redéploiement ».
