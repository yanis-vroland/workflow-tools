---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Points d.attention[^\n]*\n(?:(?!\n##? )[\s\S])*?(?:\b15\b[^\n]*marqueurs|marqueurs[^\n]*\b15\b)'
match: contains
---

CA12 : « Points d'attention » donne le nombre total de marqueurs TODO, FIXME et HACK (15).
