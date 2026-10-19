---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '^(?:(?!\n##? [^\n]*Synth[èe]se)[\s\S])*?\b33b6f4f\b'
match: contains
---

CA15 et CA21 : le commit de l'en-tête est mis à jour (33b6f4f, commit du scaffold, déterministe).
