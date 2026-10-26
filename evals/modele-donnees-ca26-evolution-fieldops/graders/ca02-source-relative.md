---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^[-*] *\**Sources lues\** *:\**[^\n]*\.\./fieldops-brief/notes-appel\.md'
flags: m
match: contains
---

017-CA2 : la source hors du projet est listée dans l'en-tête par son chemin relatif à la racine du projet, `../fieldops-brief/notes-appel.md`.
