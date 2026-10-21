---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*Constats dans le code[^\n]*\n(?:(?!\n## )[\s\S])*?\n### S\d+(?=(?:(?!\n###? )[\s\S])*?\bDELETE\b[^\n]{0,10}/(?:api/)?interventions/:id)'
match: contains
---

CA13 : le constat cite la route avec sa méthode HTTP (`DELETE /api/interventions/:id` ou
`DELETE /interventions/:id`).
