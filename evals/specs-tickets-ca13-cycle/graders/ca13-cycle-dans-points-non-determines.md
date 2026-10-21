---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: '^#{1,6} +(\d+\.? +)?Points non déterminés *$[\s\S]*\bcycl'
flags: mi
match: contains
---

006-CA13 : la section « Points non déterminés » décrit un cycle de dépendances.
