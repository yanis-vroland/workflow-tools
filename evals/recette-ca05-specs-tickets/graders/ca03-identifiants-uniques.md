---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*(REC-\d{3})\s*\|[\s\S]*\n\|\s*\1\s*\|'
match: not_contains
---

CA3 : aucun identifiant REC-nnn n'ouvre deux lignes de tableau du livrable.
