---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^(?:[^\n]*\n){0,15}[^\n]*Commit analysé *: *`?2fc99c0\b[^\n]*modifications non commitées'
match: contains
---

005-CA3 (ADR-001) : l'arbre de travail contient une modification non commitée (`src/domain/scheduling.ts`) ; la ligne « Commit analysé » de l'en-tête porte le commit puis la mention « modifications non commitées ».
