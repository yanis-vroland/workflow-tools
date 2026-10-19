---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '^(?:(?!\n##? [^\n]*Synth[èe]se)[\s\S])*?\b8de0c62\b'
match: contains
---

CA21 : l'en-tête donne le commit analysé (8de0c62, commit des livrables du scaffold, déterministe).
