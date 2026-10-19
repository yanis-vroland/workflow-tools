---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n### S4\b(?=(?:(?!\n###? )[\s\S])*?\bDELETE\b)'
match: contains
---

CA20 : la route DELETE sans authentification, toujours présente, garde l'identifiant S4.
