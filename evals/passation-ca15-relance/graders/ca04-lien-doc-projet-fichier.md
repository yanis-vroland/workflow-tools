---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Documentation de r[ée]f[ée]rence[^\n]*\n(?:(?!\n##? )[\s\S])*?\]\((?:\./)?doc-projet\.md\)'
match: contains
---

CA4 : « Documentation de référence » renvoie au livrable wf-doc-projet en fichier unique (`doc-projet.md`).
