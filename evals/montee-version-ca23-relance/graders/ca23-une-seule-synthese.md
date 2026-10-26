---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '^(?![\s\S]*\n## Synthèse[\s\S]*\n## Synthèse)(?=[\s\S]*\n## Synthèse)(?=[\s\S]*\^17\.0\.2)'
match: contains
---

CA23 : le fichier contient un seul livrable (une seule section « Synthèse »), pas l'ancien suivi du nouveau. Le motif exige aussi la contrainte actuelle de react (`^17.0.2`), absente de l'ancien livrable déposé par le scaffold, pour ne pas réussir sur l'état initial.
