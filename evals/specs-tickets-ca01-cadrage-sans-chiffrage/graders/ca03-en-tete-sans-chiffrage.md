---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: '^(?:(?!\n#{1,2} )[\s\S])*?chiffrage\.md'
match: not_contains
---

006-CA3 : l'en-tête ne présente pas `chiffrage.md` comme lu (il n'existe pas dans ce projet).
