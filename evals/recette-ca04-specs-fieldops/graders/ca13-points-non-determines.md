---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n##? [^\n]*Points non d[ée]termin[ée]s(?:(?!\n##? )[\s\S])*003-export-pdf\.md'
match: contains
---

CA13 : « Points non déterminés » liste la spec en brouillon (docs/specs/003-export-pdf.md).
