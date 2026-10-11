---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Lancer le projet[^\n]*\n(?:(?!\n##? )[\s\S])*?(?:non déterminé|aucune commande)'
flags: "i"
match: contains
---

CA19 : sans commande de lancement identifiable, « Lancer le projet » le dit.
