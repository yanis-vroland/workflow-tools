---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '^(?:(?!\n##? [^\n]*Synth[èe]se)[\s\S])*?stack Python non couverte en v1'
flags: "i"
match: contains
---

CA19 : l'en-tête indique « stack Python non couverte en v1 ».
