---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*D[ée]pendances vuln[ée]rables[^\n]*\n(?:(?!\n## )[\s\S])*?aucun constat'
flags: 'i'
match: contains
---

CA19 : « Dépendances vulnérables » indique « aucun constat ».
