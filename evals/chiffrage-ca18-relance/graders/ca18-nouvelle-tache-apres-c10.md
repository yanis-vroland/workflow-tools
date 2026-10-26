---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^\| *C(?:1[1-9]|[2-9]\d) *\|[^|\n]*\|[^|\n]*\bB06\b'
flags: m
match: contains
---

005-CA18 : le nouveau besoin B06 est couvert par une tâche dont l'identifiant suit le dernier attribué (C11 ou au-delà).
