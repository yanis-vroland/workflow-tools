---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '^(?:(?!\n##? [^\n]*Avant de commencer)[\s\S])*?(?:\d{4}-\d{2}-\d{2}|\d{2}/\d{2}/\d{4}|\d{1,2}(?:er)? (?:janvier|février|mars|avril|mai|juin|juillet|août|septembre|octobre|novembre|décembre) \d{4})'
match: contains
---

CA15 : l'en-tête donne la date.
