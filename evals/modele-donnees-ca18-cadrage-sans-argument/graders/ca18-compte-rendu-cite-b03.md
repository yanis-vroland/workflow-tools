---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^\| *Compte rendu[^|\n]*\|(?:[^|\n]*\|){4}[^|\n]*\bB03\b'
flags: m
match: contains
---

017-CA18 : les attributs du compte rendu (B03) citent B03 dans le dictionnaire.
