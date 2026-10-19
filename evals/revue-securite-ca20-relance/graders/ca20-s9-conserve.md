---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n### S9\b(?=(?:(?!\n###? )[\s\S])*?auth_service\.dart)'
match: contains
---

CA20 : le jeton dans `shared_preferences`, toujours présent, garde l'identifiant S9.
