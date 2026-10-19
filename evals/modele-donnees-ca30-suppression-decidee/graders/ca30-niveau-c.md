---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^[-*] *\**Niveau atteint\** *: *\**C\b'
flags: m
match: contains
---

017-CA30 : relancé sans argument sur un livrable de niveau C, avec un schéma détecté, l'outil reste au niveau C.
