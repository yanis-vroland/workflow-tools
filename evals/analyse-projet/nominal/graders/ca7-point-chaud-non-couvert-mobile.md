---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Dette et risques[^\n]*\n(?:(?!^#+ [^\n]*Effort de reprise)[\s\S])*?mobile/lib/screens/intervention_list_screen\.dart'
flags: m
match: contains
---

CA7 : mobile/lib/screens/intervention_list_screen.dart, dans le top 10 et non couvert, apparaît dans « Dette et risques ».
