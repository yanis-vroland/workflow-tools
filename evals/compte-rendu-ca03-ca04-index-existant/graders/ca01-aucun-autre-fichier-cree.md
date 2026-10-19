---
type: regex
target: files
pattern: '^(?!docs/wf/compte-rendu/(?:index|2026-10-07-point-hebdomadaire)\.md$|\.git/).+$'
flags: m
match: not_contains
---

007-CA1 : la session ne crée ni ne modifie aucun fichier autre que le nouveau compte rendu et l'index (les deux comptes rendus existants, le code et les notes restent intacts).
