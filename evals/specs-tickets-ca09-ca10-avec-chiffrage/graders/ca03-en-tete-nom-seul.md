---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: '^(?:(?!\n#{1,2} )[\s\S])*?docs/wf/'
match: not_contains
---

006-CA3 : dans l'en-tête, les fichiers d'entrée sont désignés par leur nom de fichier seul, sans `docs/wf/`.
