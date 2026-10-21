---
type: regex
target: { source: file, path: "docs/wf/compte-rendu/2026-10-07-point-hebdomadaire.md" }
pattern: 'a1b2c3d'
match: not_contains
---

007-CA6 : le commit de l'en-tête vient de `git rev-parse`, pas des comptes rendus déposés (qui portent un hash factice, a1b2c3d).
