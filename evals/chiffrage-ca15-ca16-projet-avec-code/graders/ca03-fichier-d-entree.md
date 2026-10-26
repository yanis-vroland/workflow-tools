---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^(?:[^\n]*\n){0,15}[^\n]*\bcadrage-besoin\.md\b[^\n]*\b2026-10-10\b'
match: contains
---

005-CA3 : l'en-tête indique le fichier d'entrée (`cadrage-besoin.md`) et, sur la même ligne, la date de son en-tête (2026-10-10).
