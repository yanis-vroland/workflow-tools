---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^### +Relations *$(?:(?!^#{1,6} )[\s\S])*?^[-*] +(?=[^\n]* — )(?![^\n]*supposé)(?![^\n]*« [^»\n]+ » \(`?(brief-fieldops|notes-appel)\.md`?, « [^»\n]+ »\))[^\n]*$'
flags: m
match: not_contains
---

017-CA4 : dans « Relations », chaque relation (puce de la forme « A … — … B ») cite une phrase source avec le nom du fichier et le titre de section, ou est marquée « supposé ».
