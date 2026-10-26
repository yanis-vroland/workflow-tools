---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^[-*] *\**Sources lues\** *:\**[^\n]*docs/wf/cadrage-besoin\.md'
flags: m
match: contains
---

017-CA2 et CA18 : l'en-tête liste la source lue par son chemin relatif à la racine du projet, `docs/wf/cadrage-besoin.md`.
