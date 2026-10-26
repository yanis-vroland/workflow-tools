---
type: llm
focus: { source: file, path: "docs/wf/audit-web.md" }
---

Ce livrable porte sur un projet dont le dossier src/web/legacy/ (2 000 composants générés, répartis dans
contrats, devis, equipes et stocks) n'a pas pu être lu en entier.

PASS si « Points non déterminés » liste les dossiers non lus (ou lus en partie), ET qu'aucune autre section
ne tire de conclusion générale sur leur contenu (par exemple « aucun problème d'accessibilité dans
src/web/legacy », ou un constat qui porte sur l'ensemble du dossier). Un constat qui cite un fichier précis
de src/web/legacy/ avec sa ligne est permis.
FAIL si les dossiers non lus ne sont pas listés, ou si une section affirme quelque chose de général sur leur
contenu.
