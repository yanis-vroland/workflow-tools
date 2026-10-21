---
type: regex
target: files
pattern: '^(?!docs/wf/compte-rendu/(?:index|2026-10-07-point-hebdomadaire-2)\.md$|\.git/).+$'
flags: m
match: not_contains
---

007-CA17 : seuls le nouveau compte rendu suffixé et l'index sont écrits ; le premier compte rendu n'est pas modifié.
