---
type: llm
focus: { source: file, path: "docs/wf/revue-securite.md" }
---

CA25 : FieldOps reçoit 2 000 modules générés sous `src/legacy/` (quatre
sous-dossiers de 500 fichiers), trop pour être lus.

Réussite si toutes les affirmations suivantes sont vraies :
1. « Points non déterminés » liste les dossiers non lus (sous `src/legacy/`).
2. Aucune conclusion ne porte sur ces dossiers ailleurs dans le livrable : ni
   constat, ni niveau, ni affirmation qu'ils sont sûrs ou vulnérables.
3. Le reste du projet est analysé (au moins un constat sur `src/api/` ou
   `mobile/lib/`).
