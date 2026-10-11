---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Points non déterminés[^\n]*\n[\s\S]*?hébergement'
flags: mi
match: contains
---

CA19 : l'hébergement, impossible à établir (registre et webhook de déploiement en .example.invalid), figure dans « Points non déterminés ».
