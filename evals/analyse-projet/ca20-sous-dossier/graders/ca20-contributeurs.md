---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Activité du dépôt[^\n]*\n(?:(?!^#+ [^\n]*Qualité et tests)[\s\S])*?(?:(?:(?<![\d/-])4(?![\d/-])|quatre)[^\n]{0,60}contributeu|contributeu[^\n]{0,60}(?:(?<![\d/-])4(?![\d/-])|quatre))'
flags: mi
match: contains
---

CA20 : « Activité du dépôt » compte les 4 contributeurs du sous-dossier, pas les 5 du dépôt.
