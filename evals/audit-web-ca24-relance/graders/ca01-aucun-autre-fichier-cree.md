---
type: regex
target: files
pattern: '^(?!docs/wf/audit-web\.md$|\.git/).+$'
flags: "m"
match: not_contains
---

CA1 et CA24 : la session ne crée aucun fichier autre que docs/wf/audit-web.md.
