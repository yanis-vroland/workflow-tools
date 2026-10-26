---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^#{1,6} +(\d+\.? +)?Points non déterminés *$[\s\S]*/wf-cadrage-besoin'
flags: m
match: contains
---

005-CA21 : « Points non déterminés » recommande de passer par `/wf-cadrage-besoin`.
