---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '^(?=(?:[^\n]*\n){0,8}[^\n]*\b655b970)(?![\s\S]*\b0000000\b)'
match: contains
---

CA23 et ADR-001 : l'en-tête cite le commit actuel (`655b970`, HEAD du scaffold, rejouable) et plus l'ancien (`0000000`).
