---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '^(?![\s\S]*Date : 2026-10-01\b)(?![\s\S]*Outil : wf-revue-securite[\s\S]*Outil : wf-revue-securite)[\s\S]*Outil : wf-revue-securite'
match: contains
---

CA20 : le livrable est mis à jour, pas dupliqué : un seul en-tête dans le fichier.

Discriminant : le livrable déposé par le scaffold satisfait déjà la condition ; le correcteur exige
aussi que la date du livrable précédent (2026-10-01) ait disparu, donc que le fichier ait été réécrit.
