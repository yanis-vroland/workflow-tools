---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '^(?![\s\S]*2026-09-15)^(?![\s\S]*?(?:\n#{1,2} [^\n]*Plan d.action[^\n]*\n(?:(?!\n#{1,2} )[\s\S])*?\bW[256]\b))(?=[\s\S]*?wf-audit-web)'
match: contains
---

CA24 : « Plan d'action » ne reprend ni W2, ni W5, ni W6.
