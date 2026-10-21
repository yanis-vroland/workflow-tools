---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: '^[-*] *\**Commit analysé\** *:[^\n]*\b2fc99c0\b[^\n]*modifications non commitées'
flags: m
match: contains
---

006-CA3 (ADR-001) : la ligne « Commit analysé » de l'en-tête porte le commit `2fc99c0` suivi de la mention « modifications non commitées » (le cadrage déposé porte un autre commit et aucune mention).
