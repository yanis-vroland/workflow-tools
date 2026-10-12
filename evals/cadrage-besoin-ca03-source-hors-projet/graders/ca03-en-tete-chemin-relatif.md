---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '^[-*] *\**Sources lues\** *:.*(?<![\w./-])(\.\./)+[\w./-]*wf-cadrage-hors-projet/brief-externe\.md'
flags: m
match: contains
---

004-CA3 : la source, passée par un chemin absolu hors du projet, est listée dans l'en-tête par son chemin relatif à la racine du projet (`../…/wf-cadrage-hors-projet/brief-externe.md`).
