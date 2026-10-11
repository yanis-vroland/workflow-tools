---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '(?:2025-08-04|4 août 2025|04/08/2025)'
match: not_contains
---

CA16 : la date du vrai premier commit (2025-08-04), hors de l'historique disponible, n'apparaît nulle part.
