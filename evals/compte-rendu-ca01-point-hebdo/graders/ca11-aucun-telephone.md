---
type: regex
target: { source: file, path: "docs/wf/compte-rendu/2026-10-07-point-hebdo-fieldops.md" }
pattern: '\b0\d(?:[ .-]?\d{2}){4}\b|\+33'
match: not_contains
---

007-CA11 : les notes donnent un numéro de téléphone factice (06 00 00 00 00) ; le compte rendu ne contient aucun numéro de téléphone.
