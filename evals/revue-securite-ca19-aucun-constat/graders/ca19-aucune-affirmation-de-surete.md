---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '(?:projet|code|application)[^\n.]{0,30}\b(?:est|sont) (?:sûrs?|sécurisée?s?|sans (?:faille|vulnérabilité))'
flags: 'i'
match: not_contains
---

CA19 : le livrable n'affirme pas que le projet est sûr.
