---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: '^(?:(?!\n#{1,2} )[\s\S])*?\b(?=[0-9a-f]*\d)(?=[0-9a-f]*[a-f])[0-9a-f]{7,40}\b'
match: not_contains
---

006-CA3 (ADR-001) : le répertoire n'est pas un dépôt git ; l'en-tête ne contient aucun hash de commit (il indique « non déterminé »).
