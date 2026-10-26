---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Travaux en cours[^\n]*\n(?:(?!\n##? )[\s\S])*?branche principale[^\n]*non déterminée|\n##? [^\n]*Travaux en cours[^\n]*\n(?:(?!\n##? )[\s\S])*?non déterminée[^\n]*branche principale'
flags: "i"
match: contains
---

CA11 : « Travaux en cours » indique que la branche principale n'est pas déterminée.
