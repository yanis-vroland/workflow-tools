---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^(?:(?!\n#+ [^\n]*Synthèse)[\s\S])*?hors git'
flags: i
match: contains
---

CA15 (dépôt parent qui ne suit pas le projet) : l'en-tête indique « hors git ».
