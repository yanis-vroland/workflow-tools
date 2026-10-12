---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '^#{1,6} +(\d+\.? +)?Points non déterminés *$[\s\S]*compte-rendu-visio\.md'
flags: m
match: contains
---

004-CA15 : la source `compte-rendu-visio.md`, listée dans l'en-tête mais introuvable, est signalée dans « Points non déterminés ».
