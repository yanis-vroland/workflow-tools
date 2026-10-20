---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?Règles de gestion *$(?:(?!^## )[\s\S])*?^[-*] +\**RG\d\d\b(?![^\n]*(Source\s*:|supposé))[^\n]*$'
flags: m
match: not_contains
---

017-CA7 : chaque règle `RGnn` de « Règles de gestion » a une source (« Source : ») ou la marque « supposé ».
