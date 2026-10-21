---
type: regex
target: files
pattern: '^(?!docs/wf/compte-rendu/(?:index|2026-10-14-revue-de-sprint-3)\.md$|\.git/).+$'
flags: m
match: not_contains
---

007-CA1 et CA2 : seuls le compte rendu et l'index sont écrits ; le texte collé n'est enregistré dans aucun fichier intermédiaire.
