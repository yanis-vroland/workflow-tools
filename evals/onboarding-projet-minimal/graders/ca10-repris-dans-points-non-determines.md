---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Points non d[ée]termin[ée]s[^\n]*\n(?:(?!\n##? )[\s\S])*?contribu'
flags: "i"
match: contains
---

CA10 : l'absence de convention de contribution est reprise dans « Points non déterminés ».
