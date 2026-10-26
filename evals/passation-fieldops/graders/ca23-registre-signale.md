---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '(?<=\n)(?=[^\n]*à paramétrer au redéploiement)(?=[^\n]*deploy\.yml[^\n]*\b(?:29|30|31|44|45|46)\b)'
match: contains
---

CA23 : une ligne « à paramétrer au redéploiement » signale l'adresse du registre d'images de `.github/workflows/deploy.yml`, avec une de ses lignes (29 à 31, 44 à 46).
