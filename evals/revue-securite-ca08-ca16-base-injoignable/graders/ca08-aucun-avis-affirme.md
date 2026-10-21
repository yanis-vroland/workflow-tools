---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*D[ée]pendances vuln[ée]rables[^\n]*\n(?:(?!\n## )[\s\S])*?(?:CVE-\d{4}|GHSA-)'
match: not_contains
---

CA8 : base injoignable, aucun avis (CVE, GHSA) n'est cité de mémoire dans « Dépendances
vulnérables ».
