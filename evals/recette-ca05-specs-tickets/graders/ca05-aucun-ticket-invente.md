---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '#T0[4-9]-|#T01-CA[3-9]|#T03-CA[2-9]|#T02-CA[4-9]'
match: not_contains
---

CA5 : aucune source ne cite un ticket ou un critère qui n'existe pas (T01 a
deux critères, T02 trois, T03 un).
