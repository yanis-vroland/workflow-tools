---
type: llm
focus: { source: file, path: "docs/wf/cadrage-besoin.md" }
---

004-CA3 (en-tête conforme à l'ADR-001, sources lues). Dans l'en-tête du livrable, avant la section « Synthèse » :

- l'outil est nommé (`wf-cadrage-besoin`) ;
- une date de génération est indiquée ;
- le répertoire n'ayant aucun commit, l'en-tête ne donne aucun hash de commit inventé (il peut indiquer que le projet n'est pas un dépôt git, ou que le commit est « non déterminé ») ;
- les sources lues sont listées : `brief-fieldops.md` et `notes-appel.md`, chacune par son nom de fichier seul, sans chemin de répertoire.

Échoue si l'un de ces points manque.
