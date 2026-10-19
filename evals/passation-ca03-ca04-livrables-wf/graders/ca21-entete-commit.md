---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '^(?:(?!\n##? [^\n]*Synth[èe]se)[\s\S])*?\b8918f31\b'
match: contains
---

CA21 : l'en-tête donne le commit analysé (8918f31, commit des livrables du scaffold, déterministe).
