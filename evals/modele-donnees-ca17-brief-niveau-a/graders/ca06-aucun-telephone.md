---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '(\+33[ .]?|\b0)[1-9]([ .-]?\d{2}){4}\b'
match: not_contains
---

017-CA6 et CA13 : aucun numéro de téléphone, réel ou tiré des sources, dans les exemples ni ailleurs dans le livrable.
