---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Secrets [àa] transmettre[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)\|(?=[^\n]*\bDEPLOY_TOKEN\b)(?=[^\n]*voir contrat d.hébergement)'
match: contains
---

CA15 : la saisie « auprès de l'hébergeur, voir contrat d'hébergement » de la colonne « Comment l'obtenir » de `DEPLOY_TOKEN` est conservée.
