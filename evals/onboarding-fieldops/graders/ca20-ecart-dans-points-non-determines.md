---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Points non d[ée]termin[ée]s[^\n]*\n(?:(?!\n##? )[\s\S])*?start:dev'
match: contains
---

CA20 : l'écart README / package.json (`start:dev`) est décrit dans « Points non déterminés ».
