---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Synth[èe]se'
match: count:1
---

CA15 : le fichier contient un seul dossier (une seule Synthèse), pas l'ancien suivi du nouveau.
