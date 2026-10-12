---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '^(?![-*] *\**Sources lues).*[\w.-]+/brief-externe\.md'
flags: m
match: not_contains
---

004-CA3 (amendement 1) : hors de la ligne « Sources lues », la source est désignée par son nom de fichier seul (`brief-externe.md`).
