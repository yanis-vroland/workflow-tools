---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: 'modifications non commitées'
match: not_contains
---

017-CA2 (ADR-001) : l'arbre de travail est propre au lancement (la source est hors du projet), l'en-tête ne porte donc pas la mention « modifications non commitées ».
