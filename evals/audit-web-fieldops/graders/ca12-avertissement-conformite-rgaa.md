---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{1,2} [^\n]*Synthèse[^\n]*\n(?:(?!\n#{1,2} )[\s\S])*?conformit[ée] (?:au )?RGAA'
flags: "i"
match: contains
---

CA12 : « Synthèse » rappelle que l'audit ne vaut pas audit de conformité RGAA.
