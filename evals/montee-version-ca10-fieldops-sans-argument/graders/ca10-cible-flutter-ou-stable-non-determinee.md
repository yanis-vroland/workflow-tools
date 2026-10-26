---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Cibles retenues[^\n]*\n(?:(?!\n## )[\s\S])*?\n(?:\d+[.)]|[-*])[ \t]+[^\n]*?\bFlutter\b|\n## Points non déterminés[^\n]*\n[\s\S]*?\bstable\b'
match: contains
---

CA10 : Flutter 3.13.9 n'est pas à la dernière stable : « Cibles retenues » a une entrée Flutter, sauf si la dernière stable n'a pas pu être établie, ce que « Points non déterminés » indique alors.
