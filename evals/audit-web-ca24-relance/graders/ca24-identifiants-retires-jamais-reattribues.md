---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{3,4} [^\n]*\bW[256]\b'
match: not_contains
---

CA24 : W2 (corrigé), W5 et W6 (retirés lors d'une exécution plus ancienne) ne sont jamais réattribués à un constat.
