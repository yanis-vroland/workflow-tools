---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Documentation de r[ée]f[ée]rence[^\n]*\n(?:(?!\n##? )[\s\S])*?\]\((?:\.\./\.\./)mobile/README\.md\)'
match: contains
---

CA3 : « Documentation de référence » liste `mobile/README.md` par un lien relatif (`../../mobile/README.md`).
