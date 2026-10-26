---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '\(`?(brief-fieldops|notes-appel)\.md`?(?![`]|, (« [^»\n]+ »|en-tête))'
match: not_contains
---

017-CA4 : chaque citation d'un fichier Markdown donne le titre de section entre « » après le nom du fichier (ou « en-tête » pour les lignes qui précèdent le premier titre).
