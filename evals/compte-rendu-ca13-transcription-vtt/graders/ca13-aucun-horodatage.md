---
type: regex
target: { source: file, path: "docs/wf/compte-rendu/2026-09-30-atelier.md" }
pattern: '\b\d{2}:\d{2}(?::\d{2})?(?:\.\d{3})?\b|-->|<v |WEBVTT'
match: not_contains
---

007-CA13 : aucun horodatage, aucune balise de tour de parole WebVTT dans le compte rendu.
