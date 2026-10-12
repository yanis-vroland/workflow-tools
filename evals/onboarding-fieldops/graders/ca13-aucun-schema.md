---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '```(?:mermaid|plantuml|dot)'
flags: "i"
match: not_contains
---

CA13 : le guide ne contient aucun schéma d'architecture.
