---
type: llm
focus: { source: file, path: "docs/wf/audit-web.md" }
---

CA12 : la section « Synthèse » donne le nombre de constats par catégorie (performance, accessibilité,
référencement, bonnes pratiques) et par niveau (élevé, moyen, faible), par exemple dans un tableau.

PASS si les quatre catégories et les trois niveaux y figurent et que les nombres donnés correspondent aux
constats (titres W<n>) effectivement présents dans les sections Performance, Accessibilité, Référencement et
Bonnes pratiques du document. FAIL si une catégorie ou un niveau manque, ou si un nombre ne correspond pas.
