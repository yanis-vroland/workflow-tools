---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^> *\**Décision\** *:\**[ \t]*\S'
flags: m
match: not_contains
---

017-CA9 : à la première exécution, aucun champ « Décision : » n'est rempli ; l'outil n'en remplit jamais.
