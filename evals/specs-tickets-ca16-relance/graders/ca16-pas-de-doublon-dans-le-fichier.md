---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: '^#{1,6} +(\d+\.? +)?Synthèse *$[\s\S]*^#{1,6} +(\d+\.? +)?Synthèse *$'
flags: m
match: not_contains
---

006-CA16 : le fichier ne contient qu'un seul livrable (une seule section « Synthèse »), le nouveau n'est pas ajouté à la suite de l'ancien.
