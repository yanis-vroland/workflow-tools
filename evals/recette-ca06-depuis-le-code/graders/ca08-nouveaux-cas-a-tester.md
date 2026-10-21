---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-\d{3}\s*\|(?:[^|\n]*\|){5}(?!\s*à tester\s*\|\s*\|\s*\n)'
match: not_contains
---

CA8 : première campagne, chaque cas porte le statut « à tester » et un commentaire vide.
