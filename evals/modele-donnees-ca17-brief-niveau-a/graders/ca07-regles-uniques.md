---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?Règles de gestion *$(?:(?!^## )[\s\S])*?^[-*] +\**(RG\d\d)\b(?:(?!^## )[\s\S])*?^[-*] +\**\2\b'
flags: m
match: not_contains
---

017-CA7 : aucun identifiant de règle n'est utilisé deux fois dans « Règles de gestion » (une règle reprise ailleurs, par exemple sous « Éléments supposés », n'est pas un doublon).
