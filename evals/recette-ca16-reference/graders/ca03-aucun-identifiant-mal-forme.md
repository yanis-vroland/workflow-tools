---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '##? [^\n]*Cas de recette(?:(?!\n##? )[\s\S])*\n\|(?!\s*(?:REC-\d{3}\s*\||ID\s*\||:?-{3}))[^\n]*\|'
match: not_contains
---

CA3 : dans « Cas de recette », chaque ligne de tableau est l'en-tête, la ligne
de séparation ou un cas dont l'identifiant est REC-nnn (trois chiffres).
