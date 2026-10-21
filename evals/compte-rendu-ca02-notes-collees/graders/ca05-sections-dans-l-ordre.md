---
type: regex
target: { source: file, path: "docs/wf/compte-rendu/2026-10-14-revue-de-sprint-3.md" }
pattern: '^#{2,3} +Objet *$[\s\S]*^#{2,3} +Participants *$[\s\S]*^#{2,3} +Points abordés *$[\s\S]*^#{2,3} +Décisions *$[\s\S]*^#{2,3} +Actions *$[\s\S]*^#{2,3} +Questions en suspens *$[\s\S]*^#{2,3} +Points non déterminés *$'
flags: m
match: contains
---

007-CA5 : les sept sections, dans l'ordre de la spec, même quand certaines sont vides.
