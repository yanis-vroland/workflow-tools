---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: 'React 17|Express 4|Node\.js 18'
flags: "i"
match: not_contains
---

CA4 : la stack n'est pas décrite dans la passation (elle n'est pas recopiée depuis `doc-projet/index.md`).
