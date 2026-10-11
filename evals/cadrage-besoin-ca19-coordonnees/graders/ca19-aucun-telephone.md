---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '(\+33|\b0)[1-9]([ .-]?\d{2}){4}\b'
match: not_contains
---

004-CA19 : le numéro de téléphone de la source n'apparaît pas dans le livrable.
