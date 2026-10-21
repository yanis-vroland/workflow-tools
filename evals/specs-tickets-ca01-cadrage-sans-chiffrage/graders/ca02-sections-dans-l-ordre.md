---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: '^#{1,6} +(\d+\.? +)?Synthèse *$[\s\S]*^#{1,6} +(\d+\.? +)?Ordre de réalisation *$[\s\S]*^#{1,6} +(\d+\.? +)?Tickets *$[\s\S]*^#{1,6} +(\d+\.? +)?Besoins non couverts *$[\s\S]*^#{1,6} +(\d+\.? +)?Points non déterminés *$'
flags: m
match: contains
---

006-CA2 : les cinq sections contractuelles sont des titres Markdown portant exactement les noms de la spec (numérotation facultative), dans l'ordre.
