---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: 'Outil : wf-revue-securite[\s\S]*Outil : wf-revue-securite'
match: not_contains
---

CA20 : le livrable est mis à jour, pas dupliqué : un seul en-tête dans le fichier.
