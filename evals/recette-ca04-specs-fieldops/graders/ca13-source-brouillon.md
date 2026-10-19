---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-\d{3}\s*\|(?:[^|\n]*\|){4}[^|\n]*003-export-pdf\.md#CA[1-3]\b[^|\n]*spec brouillon'
match: contains
---

CA13 : les cas de la spec en brouillon (003) sont générés, et leur colonne
Source porte la mention « spec brouillon ».
