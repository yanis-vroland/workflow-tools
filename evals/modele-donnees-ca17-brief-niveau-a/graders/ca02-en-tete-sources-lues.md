---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '(?<![\s\S])(?:(?!^## )[\s\S])*?^[-*] *\**Sources lues\** *:\**(?=[^\n]*(^|[\s,`])brief-fieldops\.md\b)(?=[^\n]*(^|[\s,`])notes-appel\.md\b)'
flags: m
match: contains
---

017-CA2 : l'en-tête liste les deux sources lues, `brief-fieldops.md` et `notes-appel.md`, par leur chemin relatif à la racine du projet (ici leur nom seul, précédé d'un espace, d'une virgule ou d'un accent grave, donc sans répertoire).
