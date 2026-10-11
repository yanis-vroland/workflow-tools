---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '```[^`]*npm run start:dev|\n *\d+\.[^\n]*npm run start:dev'
match: not_contains
---

CA20 : la commande `npm run start:dev` du README, absente des scripts de `package.json`, n'est donnée dans aucune étape.
