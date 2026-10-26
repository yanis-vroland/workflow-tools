---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '^(?=(?:[^\n]*\n){0,8}[^\n]*\b7863f6e)[\s\S]*?\n## Synthèse[^\n]*\n[\s\S]*\n## Inventaire des versions[^\n]*\n[\s\S]*\n## Cibles retenues[^\n]*\n[\s\S]*\n## Ruptures et impacts[^\n]*\n[\s\S]*\n## Plan de montée[^\n]*\n[\s\S]*\n## Vérifications[^\n]*\n[\s\S]*\n## Points non déterminés'
match: contains
---

CA2 : les sept sections sont présentes, dans l'ordre, dans le livrable mis à jour. L'ancien livrable déposé par le scaffold a les mêmes sections : le motif exige aussi le commit actuel (`7863f6e`) dans l'en-tête, absent de l'ancien, pour ne pas réussir sur l'état initial.
