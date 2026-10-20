---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^## +Sécurité[^\n]*\n(?:(?!## )[^\n]*\n)*?[^\n]*src/legacy'
flags: m
match: not_contains
---

CA18 : aucun signal de « Sécurité » ne porte sur les dossiers non lus de `src/legacy/`.
