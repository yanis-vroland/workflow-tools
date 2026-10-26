---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?Dictionnaire de données *$(?:(?!^#{1,6} )[\s\S])*?^\|\s*Entité\s*\|\s*Champ\s*\|\s*Type\s*\|\s*Obligatoire\s*\|\s*Exemple\s*\|\s*Source\s*\|'
flags: m
match: contains
---

017-CA6 : « Dictionnaire de données » contient un tableau aux colonnes `Entité | Champ | Type | Obligatoire | Exemple | Source`.
