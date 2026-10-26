---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Points d.attention[^\n]*\n(?:(?!\n##? )[\s\S])*?à paramétrer au redéploiement'
match: contains
---

CA23 : les adresses écrites en dur sont signalées « à paramétrer au redéploiement » dans « Points d'attention ».
