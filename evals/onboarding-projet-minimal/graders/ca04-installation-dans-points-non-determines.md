---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Points non d[ée]termin[ée]s[^\n]*\n(?:(?!\n##? )[\s\S])*?\n[-*] [^\n]*install'
flags: i
match: contains
---

CA4 : l'absence de commande d'installation est reprise dans « Points non
déterminés ».
