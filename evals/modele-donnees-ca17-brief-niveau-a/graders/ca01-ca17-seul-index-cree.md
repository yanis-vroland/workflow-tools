---
type: regex
target: files
pattern: '^(?!(.*/)?docs/wf/modele-donnees/index\.md$).+$'
flags: m
match: not_contains
---

017-CA1 et CA17 : aucun fichier autre que `docs/wf/modele-donnees/index.md` n'est créé ; au niveau A, le dossier ne contient donc aucun fichier non Markdown.
