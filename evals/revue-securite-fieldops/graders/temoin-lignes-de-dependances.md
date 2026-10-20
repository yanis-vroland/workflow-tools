---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*D[ée]pendances vuln[ée]rables[^\n]*\n(?:(?!\n## )[\s\S])*?\n\| S\d+ \|'
match: contains
---

Témoin de `ca05-forme-des-entrees` : le tableau a au moins une ligne.
