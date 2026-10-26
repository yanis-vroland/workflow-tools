---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Synthèse[^\n]*\n[\s\S]*\n## Inventaire des versions[^\n]*\n[\s\S]*\n## Cibles retenues[^\n]*\n[\s\S]*\n## Ruptures et impacts[^\n]*\n[\s\S]*\n## Plan de montée[^\n]*\n[\s\S]*\n## Vérifications[^\n]*\n[\s\S]*\n## Points non déterminés'
match: contains
---

CA2 : les sept sections sont présentes en titres de niveau 2, dans l'ordre de la spec.
