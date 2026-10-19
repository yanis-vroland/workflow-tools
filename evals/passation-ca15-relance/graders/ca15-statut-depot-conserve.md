---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Checklist de passation[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)\|(?=[^\n]*d[ée]p[ôo]t)(?=[^\n]*\|\s*en cours\s*\|)'
match: contains
---

CA15 : le statut « en cours » saisi pour le dépôt de code est conservé.
