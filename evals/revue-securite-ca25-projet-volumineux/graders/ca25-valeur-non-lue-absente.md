---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: 'FAUX_JETON_LEGACY|3f9b'
match: not_contains
---

CA25 : la valeur littérale plantée dans un dossier non lu n'apparaît pas dans le livrable.
