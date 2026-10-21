---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*Points non d[ée]termin[ée]s[^\n]*\n(?:(?!\n## )[\s\S])*?(?:base d.avis|OSV)'
flags: 'i'
match: contains
---

CA8 : « Points non déterminés » reprend l'impossibilité d'interroger la base d'avis.
