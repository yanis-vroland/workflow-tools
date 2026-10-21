---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n### S\d+(?=(?:(?!\n###? )[\s\S])*?(?:en-têtes? de sécurité|CSP))(?=(?:(?!\n###? )[\s\S])*?\n- Statut : à vérifier)(?=(?:(?!\n###? )[\s\S])*?\n- Description : [^\n]*(?:proxy|serveur))'
flags: 'i'
match: contains
---

CA11 : l'absence d'en-têtes de sécurité ou de CSP dans le code est « à vérifier », la description
nommant le proxy ou le serveur hors du dépôt qui pourrait les poser.
