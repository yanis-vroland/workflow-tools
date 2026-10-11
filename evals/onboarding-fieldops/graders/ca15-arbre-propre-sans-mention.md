---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: 'modifications non commitées'
match: not_contains
---

CA15 : arbre de travail propre, donc pas de mention « modifications non commitées ».
