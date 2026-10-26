---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '^#{1,6} +(?:\d+\.? +)?Points non déterminés *\n(?:(?!#{1,6} )[^\n]*\n)*?[^\n]*notes-[^\n]*refusé'
flags: m
match: contains
---

004-CA17 (amendement) : « Points non déterminés » nomme le fichier écarté et indique son refus, sur la même ligne.
