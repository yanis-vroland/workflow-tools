---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '^- Q01\b.*\n\s*Réponse :'
flags: m
match: contains
---

004-CA11 : la première question est un élément de liste qui commence par l'identifiant `Q01`, suivi à la ligne suivante d'un champ « Réponse : ».
