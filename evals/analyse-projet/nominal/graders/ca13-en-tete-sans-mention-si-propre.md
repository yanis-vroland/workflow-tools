---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^(?:(?!\n#+ [^\n]*Synthèse)[\s\S])*?modifications non commitées'
match: not_contains
---

CA13 : l'arbre de travail est propre (le fichier d'environnement est ignoré par git), l'en-tête ne porte donc pas la mention « modifications non commitées ».
