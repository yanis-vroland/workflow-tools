---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '^#{1,6} +(?:\d+\.? +)?Points non déterminés *\n(?:(?!#{1,6} )[^\n]*\n)*?[^\n]*WF_SOURCES_7c3e[^\n]*refusé'
flags: m
match: contains
---

004-CA17 (amendement) : « Points non déterminés » nomme la source écartée (`WF_SOURCES_7c3e`) et indique son refus, sur la même ligne.
