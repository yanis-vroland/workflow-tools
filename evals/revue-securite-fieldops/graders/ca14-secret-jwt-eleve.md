---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*Secrets et configuration[^\n]*\n(?:(?!\n## )[\s\S])*?\n### S\d+(?=(?:(?!\n###? )[\s\S])*?middleware/auth\.ts[^\n]{0,15}\b6\b)(?=(?:(?!\n###? )[\s\S])*?élevé)'
match: contains
---

CA14 : la valeur littérale affectée à `JWT_SECRET` (`src/api/middleware/auth.ts`, ligne 6) donne un
constat de niveau élevé dans « Secrets et configuration ».
