---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^(?:(?!\n#+ [^\n]*Synthèse)[\s\S])*?hors git'
flags: i
match: not_contains
---

CA20 : un sous-dossier d'un dépôt git n'est pas « hors git ».
