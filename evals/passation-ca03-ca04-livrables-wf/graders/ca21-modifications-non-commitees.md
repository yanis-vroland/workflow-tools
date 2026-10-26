---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '^(?:(?!\n##? [^\n]*Synth[èe]se)[\s\S])*?modifications non commitées'
flags: "i"
match: contains
---

CA21 : arbre de travail modifié (`src/domain/scheduling.ts`), l'en-tête porte la mention « modifications non commitées ».
