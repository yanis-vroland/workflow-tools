---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Points non d[ée]termin[ée]s[^\n]*\n(?:(?!\n##? )[\s\S])*?\n[-*] (?=[^\n]*\btests?\b)(?=[^\n]*(?:aucun|non d[ée]termin|identifi))'
flags: "i"
match: contains
---

CA5 : l'absence de commande de test est reprise dans « Points non déterminés », sur une puce qui parle des tests et dit qu'aucune commande n'a été identifiée.
