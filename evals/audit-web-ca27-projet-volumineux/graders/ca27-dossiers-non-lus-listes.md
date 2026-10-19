---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{1,2} [^\n]*Points non d[ée]termin[ée]s[^\n]*\n(?:(?!\n#{1,2} )[\s\S])*?src/web/legacy'
match: contains
---

CA27 : « Points non déterminés » liste les dossiers non lus sous src/web/legacy/.
