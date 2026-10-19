---
type: llm
focus: { source: file, path: "docs/wf/modele-donnees/index.md" }
---

017-CA9 (amendement 2 de l'ADR-001). Les sources ne tranchent pas certains choix de modélisation (par exemple : ce qu'il advient d'un technicien qui quitte l'entreprise, le rattachement d'un équipement à un client ou à un site, l'historisation des changements d'état d'une intervention).

Dans la section « À décider » :

- il y a au moins un encadré, chacun avec un identifiant unique `Dnn` (`D01`…) et un titre ;
- chaque encadré donne le contexte qui rend le choix nécessaire, avec sa source (phrase citée ou « supposé ») ;
- chaque encadré propose au moins deux options, chacune avec ses conséquences ;
- chaque encadré se termine par un champ « Décision : » vide ;
- aucune option n'est recommandée, préférée ou présentée comme la meilleure, ni dans l'encadré ni ailleurs dans le livrable, et le reste du livrable ne tient pour acquise aucune option d'un encadré non décidé.

Échoue si l'un de ces points est faux.
