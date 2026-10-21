---
type: regex
target: { source: file, path: "docs/wf/compte-rendu/2026-10-07-point-hebdo-fieldops.md" }
pattern: '^(?:(?!\n#{2,3} +Objet)[\s\S])*?hors git'
match: contains
---

007-CA19 : la fixture n'est pas un dépôt git ; le compte rendu est produit, avec « hors git » dans l'en-tête (avant la section « Objet »).
