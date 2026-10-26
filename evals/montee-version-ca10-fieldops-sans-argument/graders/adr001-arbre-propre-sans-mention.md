---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: 'modifications non commitées'
flags: i
match: not_contains
---

ADR-001 : l'arbre de travail est propre (le livrable en cours d'écriture ne compte pas) : pas de mention « modifications non commitées ».
