---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Points non déterminés[^\n]*\n[\s\S]*?src/legacy'
flags: mi
match: contains
---

CA18 : « Points non déterminés » liste les dossiers non lus sous src/legacy/.
