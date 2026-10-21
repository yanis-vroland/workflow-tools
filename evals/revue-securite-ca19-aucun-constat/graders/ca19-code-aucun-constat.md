---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*Constats dans le code[^\n]*\n(?:(?!\n## )[\s\S])*?aucun constat'
flags: 'i'
match: contains
---

CA19 : « Constats dans le code » indique « aucun constat ».
