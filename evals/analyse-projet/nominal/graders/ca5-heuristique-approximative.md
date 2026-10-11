---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Qualité et tests[^\n]*\n(?:(?!^#+ [^\n]*Sécurité)[\s\S])*?approximati'
flags: mi
match: contains
---

CA5 : « Qualité et tests » précise que l'heuristique de couverture est approximative.
