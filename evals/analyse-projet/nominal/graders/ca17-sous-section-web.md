---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Architecture[^\n]*\n(?:(?!^#+ [^\n]*Activité du dépôt)[\s\S])*?^#{2,} [^\n]*(?:web|back-office|Node|React|Express)'
flags: mi
match: contains
---

CA17 : « Architecture » décrit l'application web dans une sous-section. « API » n'est pas accepté : une sous-section « API » de l'application mobile (client d'API) le contiendrait aussi.
