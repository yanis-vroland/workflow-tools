---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: '^(?:(?!\n#{1,2} )[\s\S])*?(docs/wf/|/Users/|/home/|/tmp/|/private/)'
match: not_contains
---

006-CA3 (amendement 1) : l'en-tête ne désigne aucun fichier par un répertoire ni par un chemin absolu.
