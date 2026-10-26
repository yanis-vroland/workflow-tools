---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '^(?:(?!\n##? [^\n]*Synth[èe]se)[\s\S])*?\d{4}-\d{2}-\d{2}'
match: contains
---

CA21 : l'en-tête donne la date.
