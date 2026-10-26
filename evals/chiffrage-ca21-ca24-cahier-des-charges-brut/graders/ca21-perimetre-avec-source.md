---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^#{1,6} +(\d+\.? +)?Périmètre chiffré *$(?:(?!^#{1,6} +(\d+\.? +)?Détail par lot *$)[\s\S])*?\bB01\b[^\n]*\bcahier-des-charges\.md\b'
flags: m
match: contains
---

005-CA21 : « Périmètre chiffré » liste B01 avec sa source, le fichier `cahier-des-charges.md`.
