---
type: llm
focus: { source: file, path: "docs/wf/recette.md" }
---

CA7 : « Périmètre et sources » liste chaque source lue avec son chemin.

Réussite si la section cite les fichiers ou dossiers de code lus avec leur
chemin relatif (au moins `src/api/routes/` ou ses fichiers, et `mobile/lib/` ou
ses fichiers), et ne présente comme lue aucune spec `docs/specs/` ni aucun
livrable `docs/wf/specs-tickets.md` (les dire absents est permis). Échec si le
code lu n'est pas cité avec ses chemins, ou si une spec ou un livrable de
tickets est présenté comme lu.
