---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Environnements et d[ée]ploiement[^\n]*\n(?:(?!\n##? )[\s\S])*?flyctl deploy --remote-only'
match: contains
---

CA5 : la commande exacte de déploiement (`flyctl deploy --remote-only`) est reprise.
