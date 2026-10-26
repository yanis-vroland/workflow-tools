---
type: regex
target: files
pattern: '^(?!(?:.*/)?docs/wf/montee-version\.md$)[^\n]*montee'
flags: mi
match: not_contains
---

CA23 : aucun second livrable (copie datée ou numérotée) n'est créé à côté de `docs/wf/montee-version.md`.
