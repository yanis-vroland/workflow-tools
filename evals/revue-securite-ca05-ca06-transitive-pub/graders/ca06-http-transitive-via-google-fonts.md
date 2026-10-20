---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*D[ée]pendances vuln[ée]rables[^\n]*\n(?:(?!\n## )[\s\S])*?(?<=\n)(?=[^\n]*\bhttp\b)(?=[^\n]*0\.12\.2)(?=[^\n]*\btransitive\b)(?=[^\n]*google_fonts)'
flags: 'i'
match: contains
---

CA6 : http est marquée « transitive » et la dépendance directe qui l'introduit, google_fonts,
est citée.
