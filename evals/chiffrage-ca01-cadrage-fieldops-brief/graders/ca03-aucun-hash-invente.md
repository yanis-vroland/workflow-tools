---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^(?:[^\n]*\n){0,15}?[^\n]*\b(?=[0-9a-f]*[a-f])(?=[0-9a-f]*\d)[0-9a-f]{7,40}\b'
match: not_contains
---

005-CA3 (ADR-001) : le projet n'a aucun commit (`claude plugin eval` ne crée qu'un dépôt vide dans le dossier parent) ; l'en-tête ne donne aucun hash de commit inventé.
