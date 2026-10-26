---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?Modèle conceptuel *$(?:(?!^#{1,6} )[\s\S])*?```mermaid\s*\n\s*erDiagram'
flags: m
match: contains
---

017-CA5 : la section « Modèle conceptuel » contient un bloc Mermaid `erDiagram`.
