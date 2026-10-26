---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^[-*] *\**Niveau atteint\** *: *\**B\b'
flags: m
match: contains
---

017-CA21 : avec `--niveau b`, le niveau B est produit malgré la question bloquante vide.
