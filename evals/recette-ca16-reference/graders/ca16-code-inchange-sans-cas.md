---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-\d{3}\s*\|(?:[^|\n]*\|){4}[^|\n]*(?:src/|mobile/)'
match: not_contains
---

CA16 : aucun fichier de code n'a changé depuis v1.3.0, aucun cas n'est donc déduit du code.
