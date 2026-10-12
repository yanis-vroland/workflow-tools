---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Stack et dépendances[^\n]*\n(?:(?!^#+ [^\n]*Architecture)[\s\S])*?react[^\n]*17\.0\.2'
flags: m
match: contains
---

CA4 : « Stack et dépendances » donne les versions du lockfile (react 17.0.2).
