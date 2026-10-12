---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^(?:(?!\n#+ [^\n]*Synthèse)[\s\S])*?\b(?=[0-9a-f]*[a-f])[0-9a-f]{7,40}\b'
match: not_contains
---

CA15 (dépôt parent qui ne suit pas le projet) : l'en-tête ne porte aucun hash de commit.
