---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Environnements et d[ée]ploiement[^\n]*\n(?:(?!\n##? )[\s\S])*?docker push <[^>\n]+>/fieldops'
match: contains
---

CA5 et CA23 : la commande exacte de publication de l'image est reprise, adresse du registre remplacée par un paramètre (`docker push <registre>/fieldops:…`).
