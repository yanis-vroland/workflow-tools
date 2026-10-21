---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: 'modifications non commitées'
match: not_contains
---

006-CA3 (ADR-001) : l'arbre de travail est propre au lancement (`docs/wf/` est ignoré par git), l'en-tête ne porte donc pas la mention « modifications non commitées ».
