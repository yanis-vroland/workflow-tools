---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Points non d[ée]termin[ée]s[^\n]*\n(?:(?!\n##? )[\s\S])*?branche principale'
flags: "i"
match: contains
---

CA11 : « Points non déterminés » reprend la branche principale non déterminée.
