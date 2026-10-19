---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*Constats dans le code[^\n]*\n(?:(?!\n## )[\s\S])*?\n### S\d+(?=(?:(?!\n###? )[\s\S])*?interventions\.ts[^\n]{0,15}\b37\b)(?=(?:(?!\n###? )[\s\S])*?injection)'
flags: 'i'
match: contains
---

CA22 : dans le projet mixte, la partie JS/TS est analysée normalement (injection de
`src/api/routes/interventions.ts`, ligne 37).
