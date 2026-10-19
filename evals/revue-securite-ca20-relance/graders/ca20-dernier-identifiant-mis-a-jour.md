---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '^(?:(?!\n## )[\s\S])*?Dernier identifiant attribué : S(?:1[2-9]|[2-9]\d)\b'
match: contains
---

CA20 : l'en-tête porte le nouveau dernier identifiant attribué (S12 ou plus).
