---
type: regex
target: files
pattern: '^(?!docs/wf/compte-rendu/(?:index|2026-10-07-point-hebdo-fieldops)\.md$|\.git/).+$'
flags: m
match: not_contains
---

007-CA16 : aucun autre fichier n'est créé, en particulier aucun doublon (`…-2.md` ou autre nom) du compte rendu de la réunion.
