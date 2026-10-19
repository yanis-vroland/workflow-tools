---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^(?:[^\n]*\n){0,15}[^\n]*Commit analysé *: *`?2fc99c0\b'
flags: m
match: contains
---

005-CA3 (ADR-001) : la ligne « Commit analysé » de l'en-tête donne `git rev-parse --short HEAD` de la fixture reconstruite (historique déterministe).
