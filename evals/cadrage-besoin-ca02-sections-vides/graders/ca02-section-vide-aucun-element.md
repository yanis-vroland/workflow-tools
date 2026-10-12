---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '^#{1,6} +(\d+\.? +)?Hors périmètre *\n\s*([-*] +)?Aucun élément\.'
flags: m
match: contains
---

004-CA2 : la source n'exclut rien explicitement ; la section « Hors périmètre » est présente et porte « Aucun élément. » au lieu d'être omise ou remplie par déduction.
