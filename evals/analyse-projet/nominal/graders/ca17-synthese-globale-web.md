---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Synthèse[^\n]*\n(?:(?!^#+ [^\n]*Stack et dépendances)[\s\S])*?(?:React|Express|web|Node)'
flags: mi
match: contains
---

CA17 : la synthèse reste globale et mentionne l'application web.
