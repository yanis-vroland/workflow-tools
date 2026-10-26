---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Points non d[ée]termin[ée]s[^\n]*\n(?:(?!\n##? )[\s\S])*?d[ée]ploiement'
flags: "i"
match: contains
---

CA6 : « Points non déterminés » reprend l'absence de procédure de déploiement.
