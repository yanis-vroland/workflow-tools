---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*D[ée]pendances vuln[ée]rables[^\n]*\n(?:(?!\n## )[\s\S])*?(?<=\n)(?=[^\n]*\bexpress\b)(?=[^\n]*4\.18\.2)(?=[^\n]*\bdirecte\b)'
flags: 'i'
match: contains
---

CA6 : express, déclarée dans `package.json`, est marquée « directe ».
