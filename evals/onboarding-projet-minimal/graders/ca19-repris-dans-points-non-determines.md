---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Points non d[ée]termin[ée]s[^\n]*\n(?:(?!\n##? )[\s\S])*?(?:lancement|lancer)'
flags: "i"
match: contains
---

CA19 : l'absence de commande de lancement est reprise dans « Points non déterminés ».
