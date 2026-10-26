---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^[-*] +\**E\d\d\b(?![^\n]*supposé)(?![^\n]*« [^»\n]+ » \(`?(brief-fieldops|notes-appel)\.md`?, « [^»\n]+ »\))[^\n]*$'
flags: m
match: not_contains
---

017-CA4 : chaque entité (`Enn`) cite une phrase source entre guillemets, avec le nom du fichier et le titre de section (« phrase » (`fichier.md`, « Section »)), ou est marquée « supposé ».
