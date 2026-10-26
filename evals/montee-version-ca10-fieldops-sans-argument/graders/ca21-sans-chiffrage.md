---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\b\d+(?:[.,]\d+)?\s*(?:jours?|j\.?/h|jours?-homme|semaines?|heures?)\b'
flags: i
match: not_contains
---

CA21 : aucun chiffrage en jours, semaines ou heures (c'est `wf-chiffrage`).
