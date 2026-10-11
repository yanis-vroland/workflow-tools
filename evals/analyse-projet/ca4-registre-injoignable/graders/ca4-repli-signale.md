---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Points non déterminés[^\n]*\n[\s\S]*?(?:registre|réseau)'
flags: mi
match: contains
---

CA4 : « Points non déterminés » signale que le registre n'a pas pu être interrogé.
