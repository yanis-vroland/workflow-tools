---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Environnements et d[ée]ploiement[^\n]*\n(?:(?!\n##? )[\s\S])*?\b[Rr]ecette\b'
match: contains
---

CA5 : l'environnement de recette (`environment: recette`) est identifié.
