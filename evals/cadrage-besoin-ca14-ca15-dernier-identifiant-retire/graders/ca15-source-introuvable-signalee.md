---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '^#{1,6} +(\d+\.? +)?Points non déterminés *$[\s\S]*ancien-brief\.md'
flags: m
match: contains
---

004-CA15 : la source introuvable `ancien-brief.md` est de nouveau signalée dans « Points non déterminés ».
