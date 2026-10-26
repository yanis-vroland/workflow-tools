---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Environnements et d[ée]ploiement[^\n]*\n(?:(?!\n##? )[\s\S])*?curl[^\n]*?\s(?:https?://)?<[^>\n]+>'
match: contains
---

CA23 et CA5 : la commande `curl` du webhook est reprise avec l'adresse remplacée par un paramètre, avec ou sans le schéma (`https://<serveur>/…` ou `<serveur-de-déploiement>/…`).
