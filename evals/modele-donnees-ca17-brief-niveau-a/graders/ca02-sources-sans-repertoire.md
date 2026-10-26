---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '[\w.~-]*/(brief-fieldops|notes-appel)\.md'
match: not_contains
---

017-CA2 : les sources, à la racine du projet, ne sont jamais désignées avec un répertoire (ni `./`, ni chemin absolu), ni dans l'en-tête, ni ailleurs.
