---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Checklist de passation[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)\|(?=[^\n]*paiement)(?=[^\n]*\|\s*à faire\s*\|)'
flags: "i"
match: contains
---

CA14 : une ligne de la checklist porte sur le transfert de l'accès au service de paiement, au statut « à faire ».
