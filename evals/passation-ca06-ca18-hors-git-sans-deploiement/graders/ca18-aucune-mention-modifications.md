---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '^(?:(?!\n##? [^\n]*Synth[èe]se)[\s\S])*?modifications non commitées'
flags: "i"
match: not_contains
---

CA18 et CA21 : hors git, l'en-tête (avant la Synthèse) ne porte pas la mention « modifications non commitées ».
