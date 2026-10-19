---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Checklist de passation[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)\|(?=[^\n]*cartographie)(?=[^\n]*\|\s*fait\s*\|)'
flags: "i"
match: contains
---

CA15 : le statut « fait » saisi pour le transfert de l'accès au service de cartographie est conservé.
