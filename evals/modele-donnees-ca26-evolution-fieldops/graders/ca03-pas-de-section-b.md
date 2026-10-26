---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?(Schéma physique|Preuve par les cas d.usage) *$'
flags: m
match: not_contains
---

017-CA3 : « Schéma physique » et « Preuve par les cas d'usage » sont propres au niveau B ; elles n'apparaissent pas au niveau C.
