---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^#{1,6} +(\d+\.? +)?Détail par lot *$(?:(?!^#{1,6} +(\d+\.? +)?Activités transverses *$)[\s\S])*?^\| *C\d{2} *\|[^\n]*\bsrc/(?:api|web|services|domain|db|jobs)/[\w./-]+\.(?:tsx?|sql)\b'
flags: m
match: contains
---

005-CA15 : au moins une tâche de « Détail par lot » cite un fichier existant du code (`src/…`).
