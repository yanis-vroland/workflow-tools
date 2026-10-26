---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Documentation de r[ée]f[ée]rence[^\n]*\n(?:(?!\n##? )[\s\S])*?/wf-doc-projet\b'
match: not_contains
---

CA4 : le livrable wf-doc-projet est présent : aucune suggestion de lancer `/wf-doc-projet`.
