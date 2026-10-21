---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*Points non d[ée]termin[ée]s[^\n]*\n(?:(?!\n## )[\s\S])*?src/legacy'
match: contains
---

CA25 : « Points non déterminés » liste les dossiers non lus (sous `src/legacy/`).
