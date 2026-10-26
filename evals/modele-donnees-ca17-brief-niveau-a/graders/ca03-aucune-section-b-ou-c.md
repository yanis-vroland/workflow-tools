---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?(Schéma physique|Preuve par les cas d.usage|Évolution) *$'
flags: m
match: not_contains
---

017-CA3 : au niveau A, ni « Schéma physique », ni « Preuve par les cas d'usage », ni « Évolution ».
