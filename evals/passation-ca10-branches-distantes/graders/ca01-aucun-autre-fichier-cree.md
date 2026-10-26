---
type: regex
target: files
pattern: '^(?!docs/wf/passation\.md$|\.git/).+$'
flags: "m"
match: not_contains
---

CA1 : la session ne crée aucun fichier autre que docs/wf/passation.md.
