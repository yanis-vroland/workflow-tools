---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^## +Dette et risques[^\n]*\n(?:(?!## )[^\n]*\n)*?[^\n]*\blegacy\b'
flags: m
match: not_contains
---

CA18 : aucun risque de « Dette et risques » ne porte sur les dossiers non lus de `src/legacy/`, quelle que soit la forme du chemin (`legacy/`, `src\legacy\billing`…), pas même un risque « non analysé ». Remplace, avec les deux correcteurs suivants, un juge `llm` bruité sur ce long livrable (votes partagés).
