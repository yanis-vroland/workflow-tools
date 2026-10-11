---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Contribuer[^\n]*\n(?:(?!\n##? )[\s\S])*?aucune convention de contribution trouvée dans le dépôt'
match: contains
---

CA10 : « Contribuer » indique « aucune convention de contribution trouvée dans le dépôt ».
