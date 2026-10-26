---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Environnements et d[ée]ploiement[^\n]*\n(?:(?!\n##? )[\s\S])*?\.github/workflows/deploy\.yml'
match: contains
---

CA5 : « Environnements et déploiement » cite le fichier source `.github/workflows/deploy.yml`.
