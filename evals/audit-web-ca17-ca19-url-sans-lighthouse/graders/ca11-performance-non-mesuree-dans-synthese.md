---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{1,2} [^\n]*Synthèse[^\n]*\n(?:(?!\n#{1,2} )[\s\S])*?performance r[ée]elle n.a pas [ée]t[ée] mesur[ée]e'
flags: "i"
match: contains
---

CA11 : « Synthèse » précise que la performance réelle n'a pas été mesurée.
