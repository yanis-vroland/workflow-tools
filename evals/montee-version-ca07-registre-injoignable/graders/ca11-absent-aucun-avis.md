---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\bCVE-\d{4}-\d+|\bGHSA-|\bS\d+\b'
match: not_contains
---

CA11 : sans livrable de sécurité, le livrable ne cite aucun avis (CVE, GHSA) ni identifiant `Sn`.
