---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*D[ée]pendances vuln[ée]rables[^\n]*\n(?:(?!\n## )[\s\S])*?(?<=\n)(?=[^\n]*\bbody-parser\b)(?=[^\n]*1\.20\.1)(?=[^\n]*\btransitive\b)(?=[^\n]*\bexpress\b)'
flags: 'i'
match: contains
---

CA6 : body-parser 1.20.1, présente seulement dans `package-lock.json` (dépendance d'express), est
vérifiée, marquée « transitive », et la dépendance directe qui l'introduit (express) est citée.
