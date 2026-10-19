---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*Constats dans le code[^\n]*\n(?:(?!\n## )[\s\S])*?\n### S\d+(?=(?:(?!\n###? )[\s\S])*?routes/interventions\.ts[^\n]{0,15}\b37\b)(?=(?:(?!\n###? )[\s\S])*?injection)'
flags: 'i'
match: contains
---

CA12 : la requête SQL concaténée de `src/api/routes/interventions.ts` (ligne 37) donne un constat
de catégorie « injection » avec le fichier et la ligne.
