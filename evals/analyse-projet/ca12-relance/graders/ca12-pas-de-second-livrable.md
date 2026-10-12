---
type: regex
target: files
pattern: '^(?!(?:.*/)?docs/wf/analyse-projet\.md$)(?:.*/)?docs/wf/'
flags: m
match: not_contains
---

CA12 : aucun autre fichier n'est créé sous docs/wf/ (pas de copie datée ni de doublon).
