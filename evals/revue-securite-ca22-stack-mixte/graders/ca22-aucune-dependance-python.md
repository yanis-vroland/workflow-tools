---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*D[ée]pendances vuln[ée]rables[^\n]*\n(?:(?!\n## )[\s\S])*?(?:\brequests\b|PyPI)'
match: not_contains
---

CA22 : aucune dépendance Python (`requests`, `outils/import/requirements.txt`) n'est rapportée.
