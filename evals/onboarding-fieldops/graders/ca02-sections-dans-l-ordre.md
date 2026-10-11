---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Avant de commencer[\s\S]*\n##? [^\n]*Installer le projet[\s\S]*\n##? [^\n]*Lancer le projet[\s\S]*\n##? [^\n]*V[ée]rifier l.installation[\s\S]*\n##? [^\n]*Se rep[ée]rer dans le code[\s\S]*\n##? [^\n]*Contribuer[\s\S]*\n##? [^\n]*Glossaire m[ée]tier[\s\S]*\n##? [^\n]*Pour aller plus loin[\s\S]*\n##? [^\n]*Points non d[ée]termin[ée]s'
match: contains
---

CA2 : les neuf sections sont présentes, en titres de niveau 1 ou 2, dans l'ordre de la spec.
