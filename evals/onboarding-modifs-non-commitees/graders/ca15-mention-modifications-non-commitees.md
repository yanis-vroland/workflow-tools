---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '^(?:(?!\n##? [^\n]*Avant de commencer)[\s\S])*?modifications non commitées'
match: contains
---

CA15 : arbre de travail modifié (`src/domain/scheduling.ts`), l'en-tête porte la mention « modifications non commitées ».
