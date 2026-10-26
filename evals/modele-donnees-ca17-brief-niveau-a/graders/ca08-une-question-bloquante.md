---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?Questions au client *$(?:(?!^## )[\s\S])*?Bloquante\s*:\s*\**oui\b'
flags: m
match: contains
---

017-CA8 : au moins une question est bloquante (les sources laissent des cardinalités ouvertes).
