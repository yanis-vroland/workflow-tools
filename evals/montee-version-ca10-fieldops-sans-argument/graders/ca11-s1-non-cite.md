---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\bS1\b'
match: not_contains
---

CA11 : seules les entrées de « Dépendances vulnérables » sont reprises ; `S1`, constat dans le code du livrable de sécurité, n'est pas cité.
