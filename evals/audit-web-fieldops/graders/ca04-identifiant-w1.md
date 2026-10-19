---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{3,4} [^\n]*\bW1\b'
match: contains
---

CA4 : les constats portent des identifiants stables, le premier étant W1.
