---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '(?<=\n)(?=[^\n]*à paramétrer au redéploiement)(?=[^\n]*deploy\.yml[^\n]*\b(?:33|48)\b)'
match: contains
---

CA23 : une ligne « à paramétrer au redéploiement » signale l'adresse du webhook de `.github/workflows/deploy.yml`, avec une de ses lignes (33, 48).
