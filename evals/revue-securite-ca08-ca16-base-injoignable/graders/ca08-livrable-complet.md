---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*Constats dans le code[^\n]*\n(?:(?!\n## )[\s\S])*?\n### S\d+(?=(?:(?!\n###? )[\s\S])*?routes/interventions\.ts[^\n]{0,15}\b37\b)(?=(?:(?!\n###? )[\s\S])*?injection)'
flags: 'i'
match: contains
---

CA8 : le livrable est tout de même produit en entier : l'analyse du code a lieu (injection SQL
de `src/api/routes/interventions.ts`, ligne 37).
