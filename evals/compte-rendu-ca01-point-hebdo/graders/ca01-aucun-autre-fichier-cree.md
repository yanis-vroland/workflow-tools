---
type: regex
target: files
pattern: '^(?!docs/wf/compte-rendu/(?:index|2026-10-07-point-hebdo-fieldops)\.md$|\.git/).+$'
flags: m
match: not_contains
---

007-CA1 : la session ne crée ni ne modifie aucun fichier autre que le compte rendu et l'index du dossier `docs/wf/compte-rendu/`.
