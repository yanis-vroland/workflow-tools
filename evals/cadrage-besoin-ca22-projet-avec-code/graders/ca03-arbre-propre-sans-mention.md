---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: 'modifications non commitées'
match: not_contains
---

004-CA3 (ADR-001) : l'arbre de travail est propre au lancement (le brief est ignoré par git), l'en-tête ne porte donc pas la mention « modifications non commitées ».
