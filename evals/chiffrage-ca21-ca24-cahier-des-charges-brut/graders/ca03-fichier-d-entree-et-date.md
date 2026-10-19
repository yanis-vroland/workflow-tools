---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^(?:[^\n]*\n){0,15}[^\n]*(?<![/\w.-])cahier-des-charges\.md\b[^\n]*(?:\b3 octobre 2026\b|\b2026-10-03\b)'
match: contains
---

005-CA3 : l'en-tête indique le fichier d'entrée par son nom seul (`cahier-des-charges.md`, sans répertoire) et, sur la même ligne, la date figurant dans l'en-tête de ce fichier : 3 octobre 2026 (ou 2026-10-03).
