---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Synthèse'
flags: m
match: count:1
---

CA12 : le contenu n'est pas dupliqué dans le fichier (une seule section « Synthèse »).
