---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*D[ée]pendances vuln[ée]rables[^\n]*\n(?:(?!\n## )[\s\S])*?\n\| S\d+ \|(?![^\n]*non déterminée \(contrainte `[^`]+`)'
match: not_contains
---

CA7 : chaque ligne présente sa version comme tirée de la contrainte déclarée (« non déterminée
(contrainte `…`, vérifiée en … ) »), jamais comme une version installée établie.
