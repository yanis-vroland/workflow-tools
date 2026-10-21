---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: '^(?:(?!\n#{1,2} )[\s\S])*?\bchiffrage\.md'
match: contains
---

006-CA3 : l'en-tête (avant la première section) liste le fichier d'entrée `chiffrage.md`.
