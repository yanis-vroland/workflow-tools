---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^\|(?!\s*Entité\s*\|)(?!\s*:?-+)(?:[^|\n]*\|){5}(?![^|\n]*(supposé|brief-fieldops\.md|notes-appel\.md))[^|\n]*\|[ \t]*$'
flags: m
match: not_contains
---

017-CA4 et CA6 : chaque ligne du dictionnaire de données (tableau à six colonnes) a une source qui nomme `brief-fieldops.md` ou `notes-appel.md`, ou la marque « supposé ».
