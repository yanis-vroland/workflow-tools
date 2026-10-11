---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Architecture[^\n]*\n(?:(?!^#+ [^\n]*Activité du dépôt)[\s\S])*?^#{2,} [^\n]*(?:web|API|back-office|Node|React|Express)'
flags: mi
match: contains
---

CA17 : « Architecture » décrit l'application web dans une sous-section.
