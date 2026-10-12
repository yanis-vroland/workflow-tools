---
type: regex
target: files
pattern: '^(?!(?:.*/)?docs/wf/analyse-projet\.md$).+$'
flags: m
match: not_contains
---

CA1 : aucun fichier n'est créé dans le projet en dehors du livrable.
