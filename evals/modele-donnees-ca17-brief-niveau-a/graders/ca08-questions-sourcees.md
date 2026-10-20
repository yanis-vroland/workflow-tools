---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?Questions au client *$(?:(?!^## )[\s\S])*?^[-*] +\**Q\d\d\b(?![^\n]*« [^»\n]+ » \(`?(brief-fieldops|notes-appel)\.md`?)[^\n]*$'
flags: m
match: not_contains
---

017-CA8 : chaque question cite la phrase source qui la motive, entre guillemets, avec le nom du fichier.
