---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '^(?=(?:[^\n]*\n){0,8}[^\n]*\b7863f6e)(?![\s\S]*\b0000000\b)'
match: contains
---

CA23 et ADR-001 : l'en-tête cite le commit actuel (`7863f6e`, HEAD du scaffold, rejouable) et plus l'ancien (`0000000`).
