---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Environnements et d[ée]ploiement[^\n]*\n(?:(?!\n##? )[\s\S])*?\n###[^\n]*\n(?:(?!\n##? )[\s\S])*?\n###'
match: contains
---

CA20 : « Environnements et déploiement » contient une sous-section par application (au moins deux titres de niveau 3).
