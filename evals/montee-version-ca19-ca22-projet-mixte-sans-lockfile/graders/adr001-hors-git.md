---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '^(?=(?:[^\n]*\n){0,8}[^\n]*wf-montee-version)(?=(?:[^\n]*\n){0,8}[^\n]*hors git)'
match: contains
---

ADR-001 : le projet n'est pas un dépôt git (le dépôt vide créé par `claude plugin eval` au-dessus n'a aucun commit) : l'en-tête indique « hors git ».
