---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*Points non d[ée]termin[ée]s[^\n]*\n(?=(?:(?!\n## )[\s\S])*?install)(?=(?:(?!\n## )[\s\S])*?transitive)'
flags: 'i'
match: contains
---

CA7 : « Points non déterminés » indique que les versions installées et les dépendances transitives
n'ont pas pu être établies.
