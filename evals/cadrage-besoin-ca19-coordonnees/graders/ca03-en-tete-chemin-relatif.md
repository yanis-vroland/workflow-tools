---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '^[-*] *\**Sources lues\** *:.*(?<![\w./-])notes/2026-10-07-point-hebdo\.md'
flags: m
match: contains
---

004-CA3 : l'en-tête « Sources lues » désigne la source par son chemin relatif à la racine du projet (`notes/2026-10-07-point-hebdo.md`).
