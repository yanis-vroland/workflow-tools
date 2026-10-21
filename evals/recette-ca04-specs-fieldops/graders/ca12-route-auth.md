---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '###? [^\n]*Fonctionnalit[ée]s sans spec(?:(?!\n##? |\n### )[\s\S])*src/api/routes/auth\.ts'
match: contains
---

CA12 : la route de connexion, qu'aucune spec ne mentionne, est listée sous
« Fonctionnalités sans spec » avec son fichier.
