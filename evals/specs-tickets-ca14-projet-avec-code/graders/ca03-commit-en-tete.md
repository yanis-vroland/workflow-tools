---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: '5b26289'
match: contains
---

006-CA3 (ADR-001) : l'en-tête indique le commit analysé, `git rev-parse --short HEAD` de la fixture reconstruite (historique déterministe).
