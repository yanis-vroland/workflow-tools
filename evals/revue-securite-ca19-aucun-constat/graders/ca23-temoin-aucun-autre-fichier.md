---
type: regex
target: files
pattern: '^(?!docs/wf/revue-securite\.md$|\.git/).+$'
flags: 'm'
match: not_contains
---

CA1 : la session ne crée aucun fichier autre que le livrable.
