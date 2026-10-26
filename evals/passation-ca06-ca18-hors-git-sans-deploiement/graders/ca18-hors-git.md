---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '^(?:(?!\n##? [^\n]*Synth[èe]se)[\s\S])*?hors git'
flags: "i"
match: contains
---

CA18 et CA21 : l'en-tête indique « hors git ».
