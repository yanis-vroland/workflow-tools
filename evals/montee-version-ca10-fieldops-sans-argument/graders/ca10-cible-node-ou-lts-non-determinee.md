---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Cibles retenues[^\n]*\n(?:(?!\n## )[\s\S])*?\n(?:\d+[.)]|[-*])[ \t]+[^\n]*?\bNode\.js\b|\n## Points non déterminés[^\n]*\n[\s\S]*?\bLTS\b'
match: contains
---

CA10 : Node.js 18 n'est pas à la dernière LTS : « Cibles retenues » a une entrée Node.js, sauf si la dernière LTS n'a pas pu être établie, ce que « Points non déterminés » indique alors.
