---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: '^[-*] *\**Commit analysé\** *:[^\n]*\b2fc99c0\b'
flags: m
match: contains
---

006-CA3 (ADR-001) : la ligne « Commit analysé » de l'en-tête porte `git rev-parse --short HEAD` de la fixture reconstruite (`2fc99c0`), et non le commit `921f57c` recopié du cadrage.
