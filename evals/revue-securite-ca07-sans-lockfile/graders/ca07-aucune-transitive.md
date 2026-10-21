---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*D[ée]pendances vuln[ée]rables[^\n]*\n(?:(?!\n## )[\s\S])*?\n\| S\d+ \|[^\n]*\| transitive'
match: not_contains
---

CA7 : sans lockfile, aucune ligne du tableau n'est marquée transitive. Remplace (avec
ca07-version-tiree-de-la-contrainte) un juge llm bruité (série r7 : PASS FAIL FAIL sur un livrable
conforme).
