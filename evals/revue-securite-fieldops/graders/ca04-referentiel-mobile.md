---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*P[ée]rim[èe]tre et m[ée]thode[^\n]*\n(?:(?!\n## )[\s\S])*?OWASP Mobile Top 10[^\n]{0,20}\b20\d{2}\b'
match: contains
---

CA4 : « Périmètre et méthode » cite l'OWASP Mobile Top 10 avec l'année de son édition
(application Flutter).
