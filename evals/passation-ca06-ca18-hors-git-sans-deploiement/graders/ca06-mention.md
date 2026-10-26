---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Environnements et d[ée]ploiement[^\n]*\n(?:(?!\n##? )[\s\S])*?procédure de déploiement non trouvée dans le dépôt'
flags: "i"
match: contains
---

CA6 : « Environnements et déploiement » indique « procédure de déploiement non trouvée dans le dépôt ».
