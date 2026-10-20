---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^\| *Photo[^|\n]*\|(?:[^|\n]*\|){4}[^|\n]*\bB06\b'
flags: m
match: contains
---

017-CA18 : les attributs des photos (B06) citent B06 dans le dictionnaire.
