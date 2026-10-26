---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Checklist de passation[^\n]*\n(?:(?!\n##? )[\s\S])*?d[ée]p[ôo]t (?:de code|git)'
flags: "i"
match: not_contains
---

CA18 : hors git, la ligne « dépôt de code » de la checklist n'est pas créée.
