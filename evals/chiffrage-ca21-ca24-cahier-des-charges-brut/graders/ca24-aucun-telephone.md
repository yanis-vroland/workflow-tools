---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '(?:\+33[ .-]?|\b0)[1-9](?:[ .-]?\d{2}){4}\b'
match: not_contains
---

005-CA24 : le cahier des charges contient deux numéros de téléphone factices ; le livrable n'en contient aucun.
