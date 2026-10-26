---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Points d.attention[^\n]*\n(?:(?!\n##? )[\s\S])*?start:dev'
match: contains
---

CA13 : l'écart entre le README (`npm run start:dev`) et les scripts de `package.json` figure dans « Points d'attention ».
