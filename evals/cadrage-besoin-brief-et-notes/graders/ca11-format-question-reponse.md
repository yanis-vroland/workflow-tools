---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: 'Q01[\s\S]*?Réponse :'
match: contains
---

004-CA11 : la première question porte l'identifiant `Q01`, suivi d'un champ « Réponse : ».
