---
type: llm
focus: { source: file, path: "docs/wf/specs-tickets.md" }
---

006-CA3 (en-tête conforme à l'ADR-001, fichiers d'entrée). Dans l'en-tête du livrable, avant la section « Synthèse » :

- l'outil est nommé (`wf-specs-tickets`) ;
- une date de génération au format AAAA-MM-JJ est indiquée ;
- le répertoire n'étant pas un dépôt git, l'en-tête ne donne aucun hash de commit inventé (il indique que le commit est « non déterminé » ou que le projet n'est pas un dépôt git) ;
- les fichiers d'entrée utilisés sont listés, dont `cadrage-besoin.md`, désigné par son nom de fichier seul (ni `docs/wf/`, ni chemin absolu) ;
- aucun livrable de chiffrage n'est présenté comme lu (il n'existe pas dans ce projet).

Échoue si l'un de ces points est faux.
