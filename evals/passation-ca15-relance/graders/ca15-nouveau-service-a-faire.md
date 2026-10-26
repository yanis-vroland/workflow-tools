---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Checklist de passation[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)\|(?=[^\n]*paiement)(?=[^\n]*\|\s*à faire\s*\|)'
flags: "i"
match: contains
---

CA15 et CA14 : le reste est mis à jour : le service de paiement, absent du dossier précédent, entre dans la checklist au statut « à faire ».
