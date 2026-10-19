---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '(?<![\s\S])(?![\s\S]*2026-10-10)[\s\S]*^[-*] *\**Niveau atteint\** *: *\**C\b'
flags: m
match: contains
---

017-CA30 : relancé sans argument sur un livrable de niveau C, avec un schéma détecté, l'outil reste au niveau C.

Le livrable déposé par le scaffold contient déjà cette ligne : le motif exige aussi que la date de l'exécution précédente (2026-10-10) ait disparu.
