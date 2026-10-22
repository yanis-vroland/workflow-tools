---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Environnements et d[ée]ploiement[^\n]*\n(?:(?!\n##? )[\s\S])*?\n### [^\n]*mobile/[^\n]*\n(?:(?!\n#{2,3} )[\s\S])*?procédure de déploiement non trouvée dans le dépôt'
flags: "i"
match: contains
---

CA20 et CA6 : dans « Environnements et déploiement », la sous-section de l'application mobile indique « procédure de déploiement non trouvée dans le dépôt ».

Remplace, avec les autres correcteurs `ca20-*`, le juge `llm` `ca20-mobile-sans-deploiement`, bruité sur ce long livrable (série r17 : votes FAIL FAIL PASS sur un livrable conforme pour CA8).
