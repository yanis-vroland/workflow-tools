---
type: llm
focus: { source: file, path: "docs/wf/modele-donnees/index.md" }
---

017-CA8. Dans « Questions au client » :

- chaque question a un identifiant `Qnn` unique ;
- chaque question cite la phrase source qui la motive (entre guillemets, avec le nom du fichier) ;
- chaque question indique explicitement si elle est bloquante pour le schéma physique (oui ou non) ;
- chaque champ « Réponse : » est vide (première exécution) ;
- au moins une question est marquée bloquante.

Échoue si l'un de ces points est faux pour une question.
