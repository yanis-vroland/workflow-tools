---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*P[ée]rim[èe]tre et m[ée]thode[^\n]*\n(?:(?!\n## )[\s\S])*?(?<=\n)(?=[^\n]*mobile)(?=[^\n]*Mobile Top 10)'
match: contains
---

CA24 : « Périmètre et méthode » liste l'application Flutter (`mobile/`) avec le référentiel qui
lui est appliqué (OWASP Mobile Top 10), sur la même ligne.
