---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '^(?![\s\S]*2026-09-15)^(?![\s\S]*?(?:\n#{3,4} [^\n]*\bW[256]\b))(?=[\s\S]*?wf-audit-web)'
match: contains
---

CA24 : W2 (corrigé), W5 et W6 (retirés lors d'une exécution plus ancienne) ne sont jamais réattribués à un constat.
