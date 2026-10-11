---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Points non d[ée]termin[ée]s[^\n]*\n(?:(?!\n##? )[\s\S])*?test'
flags: "i"
match: contains
---

CA5 : l'absence de commande de test est reprise dans « Points non déterminés ».
