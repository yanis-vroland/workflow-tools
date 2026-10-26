---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^#{1,6} +(\d+\.? +)?Synthèse *$(?:(?!^#{1,6} +(\d+\.? +)?Périmètre chiffré *$)[\s\S])*?Total bas[\s\S]*?Total haut[\s\S]*^#{1,6} +(\d+\.? +)?Activités transverses *$(?:(?!^#{1,6} +(\d+\.? +)?Hypothèses *$)[\s\S])*?\| *C\d{2} *\|(?:(?!^#{1,6} +(\d+\.? +)?Hypothèses *$)[\s\S])*?Total bas(?:(?!^#{1,6} +(\d+\.? +)?Hypothèses *$)[\s\S])*?Total haut'
flags: mi
match: contains
---

005-CA8 : le total bas et le total haut figurent dans « Synthèse », et en fin de « Activités transverses », après le tableau des tâches.
