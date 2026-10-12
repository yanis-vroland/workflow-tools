---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*V[ée]rifier l.installation[^\n]*\n(?:(?!\n##? )[\s\S])*?(?:non déterminé|aucun[^\n]*test|pas de[^\n]*test)'
flags: "i"
match: contains
---

CA5 : sans commande de test, « Vérifier l'installation » l'indique.
