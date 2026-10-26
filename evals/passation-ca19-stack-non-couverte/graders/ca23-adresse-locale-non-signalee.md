---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Points d.attention[^\n]*\n(?:(?!\n##? )[\s\S])*?__main__\.py'
match: not_contains
---

CA23 : l'adresse d'écoute `0.0.0.0` de `reports/__main__.py` (adresse locale) n'est pas signalée.
