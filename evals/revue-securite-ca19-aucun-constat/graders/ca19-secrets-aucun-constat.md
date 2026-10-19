---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*Secrets et configuration[^\n]*\n(?:(?!\n## )[\s\S])*?aucun constat'
flags: 'i'
match: contains
---

CA19 : « Secrets et configuration » indique « aucun constat ».
