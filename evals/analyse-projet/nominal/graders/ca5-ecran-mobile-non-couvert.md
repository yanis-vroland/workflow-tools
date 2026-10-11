---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Qualité et tests[^\n]*\n(?:(?!^#+ [^\n]*Sécurité)[\s\S])*?mobile/lib/screens/intervention_list_screen\.dart'
flags: m
match: contains
---

CA5 : « Qualité et tests » cite l'écran Flutter non couvert mobile/lib/screens/intervention_list_screen.dart.
