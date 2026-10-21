---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*D[ée]pendances vuln[ée]rables[^\n]*\n(?:(?!\n## )[\s\S])*?(?<=\n)(?=[^\n]*\bexpress\b)(?=[^\n]*\^4\.18\.2)'
match: contains
---

CA7 : sans lockfile, express est vérifiée sur la base de sa contrainte déclarée dans `package.json`
(`^4.18.2`), citée sur sa ligne.
