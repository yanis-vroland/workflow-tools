---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Documentation de r[ée]f[ée]rence[^\n]*\n(?:(?!\n##? )[\s\S])*?\]\((?:\.\./)specs/?'
match: contains
---

CA3 : « Documentation de référence » liste la documentation propre du projet (`docs/specs/`) par un lien relatif (`../specs/…`).
