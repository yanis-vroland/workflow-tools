---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Travaux en cours[^\n]*\n(?:(?!\n##? )[\s\S])*?non applicable'
flags: "i"
match: contains
---

CA18 : « Travaux en cours » indique « non applicable ».
