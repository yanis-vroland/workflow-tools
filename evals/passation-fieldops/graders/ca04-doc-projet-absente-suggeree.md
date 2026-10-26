---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Documentation de r[ée]f[ée]rence[^\n]*\n(?:(?!\n##? )[\s\S])*?/wf-doc-projet\b'
match: contains
---

CA4 : sans livrable wf-doc-projet, « Documentation de référence » le signale et suggère de lancer `/wf-doc-projet`.
