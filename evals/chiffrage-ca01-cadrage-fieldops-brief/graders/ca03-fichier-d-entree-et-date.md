---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^(?:[^\n]*\n){0,15}[^\n]*(?<![/\w.-])cadrage-besoin\.md\b[^\n]*2026-10-14'
match: contains
---

005-CA3 : l'en-tête indique le fichier d'entrée par son nom seul (`cadrage-besoin.md`, sans répertoire) et, sur la même ligne, la date figurant dans l'en-tête de ce fichier : 2026-10-14.
