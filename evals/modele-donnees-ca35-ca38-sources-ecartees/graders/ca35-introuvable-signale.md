---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?Points non déterminés *$[\s\S]*compte-rendu-visio\.md'
flags: m
match: contains
---

017-CA35 : le fichier introuvable `compte-rendu-visio.md` est nommé dans « Points non déterminés ».
