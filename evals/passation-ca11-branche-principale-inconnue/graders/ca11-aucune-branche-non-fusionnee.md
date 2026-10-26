---
type: llm
focus: { source: file, path: "docs/wf/passation.md" }
---

CA11 : la branche principale du dépôt s'appelle `trunk` : ni `origin/HEAD`,
ni branche `main` ou `master` ne permettent de la déterminer. Une branche
`feat/export-pdf` existe.

Réussite si toutes les affirmations suivantes sont vraies :
1. « Travaux en cours » indique que la branche principale n'a pas pu être
   déterminée.
2. Aucune branche n'est déclarée non fusionnée, nulle part dans le dossier, et
   aucun nombre de commits d'avance n'est donné.
3. « Points non déterminés » reprend ce point.
4. Le dossier ne suppose pas que `trunk` est la branche principale.
