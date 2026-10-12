---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '^#{1,6} +(\d+\.? +)?Points non déterminés *$[\s\S]*cahier-des-charges\.docx'
flags: m
match: contains
---

004-CA17 : la source écartée `cahier-des-charges.docx` est signalée dans « Points non déterminés ».
