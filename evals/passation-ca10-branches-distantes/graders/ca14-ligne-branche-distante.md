---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Checklist de passation[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)\|(?=[^\n]*notifications-push)(?=[^\n]*\|\s*à faire\s*\|)'
match: contains
---

CA14 : une ligne de la checklist porte sur la branche distante `notifications-push`, au statut « à faire ».
