---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '^\s*[-*]\s*\**B0[56]\b'
flags: m
match: not_contains
---

004-CA14 : B05 et B06, retirés (ligne « Derniers identifiants attribués : B06, Q06 » de l'en-tête précédent), ne sont réattribués à aucun besoin.
