---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: '^#{1,6} +(\d+\.? +)?Ordre de réalisation *$(?:(?!^#{1,2} )[\s\S])*?^```mermaid'
flags: m
match: contains
---

006-CA12 : la section « Ordre de réalisation » contient un schéma Mermaid (bloc ```mermaid), avant la section suivante.
