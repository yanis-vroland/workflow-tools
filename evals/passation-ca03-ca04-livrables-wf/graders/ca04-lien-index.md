---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Documentation de r[ée]f[ée]rence[^\n]*\n(?:(?!\n##? )[\s\S])*?\]\((?:\./)?doc-projet/index\.md\)'
match: contains
---

CA4 : « Documentation de référence » renvoie au livrable wf-doc-projet par `doc-projet/index.md`.
