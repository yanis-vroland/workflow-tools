---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Points non déterminés[^\n]*\n[\s\S]*?(?:superficiel|tronqu|incomplet|partiel|shallow)'
flags: mi
match: contains
---

CA16 : « Points non déterminés » signale le clone superficiel.
