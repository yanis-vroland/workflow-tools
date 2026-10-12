---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '^(?![-*] *\**Sources lues).*[\w.-]+/2026-10-07-point-hebdo\.md'
flags: m
match: not_contains
---

004-CA3 (amendement 1) : hors de la ligne « Sources lues » de l'en-tête, la source est désignée par son nom de fichier seul, sans le répertoire `notes/` ni autre chemin.
