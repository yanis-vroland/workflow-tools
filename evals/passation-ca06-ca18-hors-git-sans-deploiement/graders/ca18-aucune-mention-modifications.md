---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: 'modifications non commitées'
flags: "i"
match: not_contains
---

CA18 et CA21 : hors git, aucune mention « modifications non commitées ».
