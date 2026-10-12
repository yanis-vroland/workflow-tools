---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Architecture[^\n]*\n(?:(?!^#+ [^\n]*Activité du dépôt)[\s\S])*?^#{2,} [^\n]*(?:mobile|Flutter)'
flags: mi
match: contains
---

CA17 : « Architecture » décrit l'application Flutter dans une sous-section.
