---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^\| *Intervention *\| *(état|statut)[^|\n]*\|(?:[^|\n]*\|){3}[^|\n]*\bB02\b'
flags: m
match: contains
---

017-CA18 : l'état d'une intervention (B02, suivi de l'état) cite B02 dans le dictionnaire.
