---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Avant de commencer'
match: count:1
---

CA16 : le fichier contient un seul guide (une seule section « Avant de commencer »), pas l'ancien suivi du nouveau.
