---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Checklist de passation[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)\|(?=[^\n]*\bREGISTRY_TOKEN\b)(?=[^\n]*\|\s*à faire\s*\|)'
match: contains
---

CA14 : une ligne de la checklist porte sur la transmission de `REGISTRY_TOKEN`, au statut « à faire ».
