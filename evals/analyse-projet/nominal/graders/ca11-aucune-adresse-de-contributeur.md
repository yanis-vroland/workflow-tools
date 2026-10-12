---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '(?:lea\.marchetti|hugo\.brassac|nora\.belkacem|theo\.vasseur|fieldops)@example\.invalid'
flags: i
match: not_contains
---

CA11 : le livrable ne contient aucune adresse e-mail de contributeur (l'historique de la fixture en contient quatre).
