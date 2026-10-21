---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '###? [^\n]*Fonctionnalit[ée]s sans spec(?:(?!\n##? |\n### )[\s\S])*src/api/routes/technicians\.ts'
match: contains
---

CA12 : les routes des techniciens, qu'aucune spec ne mentionne, sont listées
sous « Fonctionnalités sans spec » avec leur fichier.
