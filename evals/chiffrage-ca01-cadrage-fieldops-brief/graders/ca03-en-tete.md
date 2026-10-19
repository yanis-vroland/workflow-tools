---
type: llm
focus: { source: file, path: "docs/wf/chiffrage.md" }
---

005-CA3 (en-tête conforme à l'ADR-001, fichier d'entrée). Dans l'en-tête du livrable, avant la section « Synthèse » :

- l'outil est nommé (`wf-chiffrage`) ;
- une date de génération est indiquée, au format AAAA-MM-JJ ;
- le répertoire n'étant pas un dépôt git, l'en-tête ne donne aucun hash de commit (il indique que le projet n'est pas un dépôt git, ou que le commit est « non déterminé ») ;
- le fichier d'entrée est indiqué par son nom de fichier seul, `cadrage-besoin.md`, sans répertoire (ni `docs/wf/`, ni chemin absolu) ;
- la date figurant dans l'en-tête de ce fichier d'entrée, 2026-10-14, est indiquée et rattachée au fichier d'entrée (elle ne se confond pas avec la date de génération).

Échoue si l'un de ces points manque ou est faux.
