---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: '^(?:(?!\n#{1,2} )[\s\S])*?Fichiers d.entrée\** *:[^\n]*[\s`,(]cadrage-besoin\.md'
match: contains
---

006-CA3 : la ligne « Fichiers d'entrée » de l'en-tête liste `cadrage-besoin.md`, par son nom de fichier seul (précédé d'une espace, d'une virgule ou d'un accent grave, jamais d'un répertoire).
