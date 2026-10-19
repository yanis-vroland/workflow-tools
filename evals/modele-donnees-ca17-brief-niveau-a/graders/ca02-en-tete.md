---
type: llm
focus: { source: file, path: "docs/wf/modele-donnees/index.md" }
---

017-CA2 (en-tête conforme à l'ADR-001). Dans l'en-tête de `index.md`, avant la section « Synthèse » :

- l'outil est nommé (`wf-modele-donnees`) ;
- une date est indiquée ;
- le répertoire n'étant pas un dépôt git, aucun hash de commit n'est inventé (l'en-tête indique que le commit est « non déterminé » ou que le projet n'est pas un dépôt git) ;
- le niveau atteint est indiqué : A (modèle conceptuel) ;
- les sources lues sont listées : `brief-fieldops.md` et `notes-appel.md`, par leur chemin relatif à la racine du projet (ici leur seul nom de fichier), jamais par un chemin absolu.

Ailleurs dans le livrable, une source est désignée par son nom de fichier seul, sans répertoire.

Échoue si l'un de ces points manque ou est faux.
