---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?Points non déterminés *$[\s\S]*cahier-des-charges\.docx'
flags: m
match: contains
---

017-CA35 : le fichier au format non pris en charge `cahier-des-charges.docx` est nommé dans « Points non déterminés ».
