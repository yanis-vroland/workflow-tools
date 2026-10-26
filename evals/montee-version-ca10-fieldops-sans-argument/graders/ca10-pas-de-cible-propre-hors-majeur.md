---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n\| `([^`]+)` \|[^\n]*\| (?:mineur|correctif|à jour) \|[\s\S]*\n## Cibles retenues[^\n]*\n(?:(?!\n## )[\s\S])*?\n(?:\d+[.)]|[-*])[ \t]+`\1`'
match: not_contains
---

CA10 : une dépendance d'écart mineur, correctif ou à jour n'a pas de cible propre (entrée de premier niveau qui commence par son nom) : elle est dans le lot, ou n'est pas ciblée.
