---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*D[ée]pendances vuln[ée]rables[^\n]*\n(?:(?!\n## )[\s\S])*?non déterminé \(base d.avis injoignable\)'
match: contains
---

CA8 : « Dépendances vulnérables » indique « non déterminé (base d'avis injoignable) ».
