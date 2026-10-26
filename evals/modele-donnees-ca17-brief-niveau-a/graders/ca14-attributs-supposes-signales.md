---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^\| *([^|\s](?:[^|\n]*[^|\s])?) *\| *([^|\s](?:[^|\n]*[^|\s])?) *\|(?:[^|\n]*\|){3}[^|\n]*supposé[^|\n]*\|[ \t]*$(?![\s\S]*^### +Éléments supposés *$(?:(?!^## )[\s\S])*?\1\.\2)'
flags: m
match: not_contains
---

017-CA14 : chaque attribut marqué « supposé » dans le dictionnaire (`Entité | Champ | …`) est signalé sous « Éléments supposés » de « Revue du modèle », sous la forme `Entité.champ`.
