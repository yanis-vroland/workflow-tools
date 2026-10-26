---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Secrets [àa] transmettre[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)\|(?=[^\n]*\bFLY_API_TOKEN\b)(?=[^\n]*deploy\.yml)'
match: contains
---

CA8 : `FLY_API_TOKEN` figure dans le tableau des secrets avec le fichier qui le référence.
