---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*P[ée]rim[èe]tre et m[ée]thode[^\n]*\n(?:(?!\n## )[\s\S])*?(?<=\n)(?=[^\n]*Python)(?=[^\n]*non couverte)'
flags: 'i'
match: contains
---

CA22 : « Périmètre et méthode » signale la partie Python (`outils/import/`) « non couverte ».
