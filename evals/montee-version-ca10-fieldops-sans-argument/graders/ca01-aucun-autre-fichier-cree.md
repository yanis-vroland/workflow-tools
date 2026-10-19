---
type: regex
target: files
pattern: '^(?!(?:.*/)?docs/wf/montee-version\.md$|\.git/).+$'
flags: m
match: not_contains
---

CA1 : aucun fichier n'est créé ni modifié par la session en dehors du livrable, en particulier ni manifeste ni lockfile.
