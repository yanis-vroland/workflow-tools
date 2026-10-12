---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Synthèse[\s\S]*^#+ [^\n]*Stack et dépendances[\s\S]*^#+ [^\n]*Architecture[\s\S]*^#+ [^\n]*Activité du dépôt[\s\S]*^#+ [^\n]*Qualité et tests[\s\S]*^#+ [^\n]*Sécurité[\s\S]*^#+ [^\n]*Dette et risques[\s\S]*^#+ [^\n]*Effort de reprise[\s\S]*^#+ [^\n]*Points non déterminés'
flags: m
match: contains
---

CA2 : les neuf sections figurent en titres, dans l'ordre de la spec.
