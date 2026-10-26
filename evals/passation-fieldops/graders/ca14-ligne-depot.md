---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Checklist de passation[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)\|(?=[^\n]*d[ée]p[ôo]t)(?=[^\n]*\|\s*à faire\s*\|)'
match: contains
---

CA14 : une ligne de la checklist porte sur le transfert des droits sur le dépôt de code, au statut « à faire ».
