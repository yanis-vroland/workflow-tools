---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '^[-*] *\**Sources lues\** *:.*(?<![\w./-])\.\./briefs-externes/brief-externe\.md'
flags: m
match: contains
---

004-CA3 : la source, hors du projet, est listée dans l'en-tête par son chemin relatif à la racine du projet (`../briefs-externes/brief-externe.md`), jamais par un chemin absolu.
