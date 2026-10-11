---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^(?:(?!\n#+ [^\n]*Synthèse)[\s\S])*?sous-dossier'
flags: i
match: contains
---

CA20 : l'en-tête mentionne le sous-dossier analysé.
