---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '^#{1,6} +(\d+\.? +)?Besoins fonctionnels *$[\s\S]*B01[\s\S]*^#{1,6} +(\d+\.? +)?Questions au client *$[\s\S]*Q01'
flags: m
match: contains
---

004-CA21 (amendement 1) : dans la fixture FieldOps brief, sans code source ni git, le livrable est produit normalement, avec au moins un besoin et une question.
