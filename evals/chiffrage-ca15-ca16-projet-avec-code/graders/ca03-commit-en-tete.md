---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^(?:[^\n]*\n){0,15}[^\n]*\b2fc99c0\b'
match: contains
---

005-CA3 (ADR-001) : l'en-tête indique le commit analysé, `git rev-parse --short HEAD` de la fixture reconstruite (historique déterministe).
