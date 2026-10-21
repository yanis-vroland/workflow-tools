---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: 'Renaud|Olivier|Sophie|\bMarc\b'
match: not_contains
---

006-CA22 (ADR-001, données personnelles) : les deux personnes nommées dans le cahier des charges ne sont pas reprises dans le livrable (désignées par leur rôle si besoin).
