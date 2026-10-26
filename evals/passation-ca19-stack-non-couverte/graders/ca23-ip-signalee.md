---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Points d.attention[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)(?=[^\n]*storage\.py[^\n\d]{0,15}4\b)'
match: contains
---

CA23 : l'adresse IP écrite en dur dans `reports/storage.py` (ligne 4) est signalée avec le fichier et la ligne.
