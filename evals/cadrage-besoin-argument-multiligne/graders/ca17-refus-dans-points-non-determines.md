---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '^#{1,6} +(?:\d+\.? +)?Points non déterminés *\n(?:(?!#{1,6} )[^\n]*\n)*?[^\n]*notes-piege(?:(?!\n(?:#|- ))[\s\S]){0,120}?refusé'
flags: m
match: contains
---

004-CA17 (amendement) : « Points non déterminés » nomme l'argument écarté et indique son refus, dans le même élément de liste (l'argument tient sur deux lignes).
