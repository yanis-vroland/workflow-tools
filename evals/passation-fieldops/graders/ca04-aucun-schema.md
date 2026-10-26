---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '```(?:mermaid|plantuml|dot)'
flags: "i"
match: not_contains
---

CA4 : le dossier ne décrit pas l'architecture (aucun schéma).
