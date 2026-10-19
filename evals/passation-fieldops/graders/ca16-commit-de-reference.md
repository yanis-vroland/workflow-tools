---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Synth[èe]se[^\n]*\n(?:(?!\n##? )[\s\S])*?\b5b26289'
match: contains
---

CA16 : la Synthèse donne le commit de référence (5b26289, dernier commit de main de la fixture).
