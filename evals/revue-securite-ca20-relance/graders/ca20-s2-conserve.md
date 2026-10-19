---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n### S2\b(?=(?:(?!\n###? )[\s\S])*?interventions\.ts)(?=(?:(?!\n###? )[\s\S])*?injection)'
flags: 'i'
match: contains
---

CA20 : l'injection SQL de `src/api/routes/interventions.ts`, toujours présente, garde l'identifiant S2.
