---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '^(?:(?!\n##? [^\n]*Synth[èe]se)[\s\S])*?\ba2ef90b\b'
match: contains
---

CA15 et CA21 : le commit de l'en-tête est mis à jour (a2ef90b, commit du scaffold, déterministe).
