---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Checklist de passation[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)\|(?=[^\n]*\bREGISTRY_TOKEN\b)(?=[^\n]*\|\s*fait\s*\|)'
match: contains
---

CA15 : le statut « fait » saisi pour la transmission de `REGISTRY_TOKEN` est conservé.
