---
type: regex
target: { source: file, path: "docs/wf/compte-rendu/2026-10-07-point-hebdomadaire.md" }
pattern: '^(?:(?!\n#{2,3} +Objet)[\s\S])*?\b2fc99c0\b'
match: contains
---

007-CA6 (ADR-001) : l'en-tête donne le commit du projet (`git rev-parse --short HEAD` de la fixture reconstruite, déterministe : 2fc99c0).
