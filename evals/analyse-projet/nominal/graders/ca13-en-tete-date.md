---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^(?:(?!\n#+ [^\n]*Synthèse)[\s\S])*?(?:\d{4}-\d{2}-\d{2}|\d{1,2}(?:er)? (?:janvier|février|mars|avril|mai|juin|juillet|août|septembre|octobre|novembre|décembre) \d{4}|\d{2}/\d{2}/\d{4})'
match: contains
---

CA13 : l'en-tête indique une date.
