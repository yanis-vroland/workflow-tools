---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^#{1,6} +(\d+\.? +)?Synthèse *$'
flags: m
match: "count:1"
---

005-CA18 : le fichier contient un seul livrable (une seule section « Synthèse »), pas l'ancien suivi du nouveau.
