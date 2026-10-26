---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '[\w./-]+\.(?:tsx?|jsx?|mjs|dart|py|php|rb|go|java|kt|swift|vue|sql)\b|(?:^|[\s`(])(?:src|lib|app|apps|mobile)/|code existant pris en compte|dossiers lus'
flags: mi
match: not_contains
---

005-CA22 (et CA15 par contraste) : le projet ne contient aucun code source ; le livrable ne cite aucun fichier ni dossier de code et ne prétend pas avoir pris en compte du code existant. Remplace le juge `llm` ca22-aucun-code-existant-invente, bruité sur ce long livrable (FAIL FAIL PASS).
