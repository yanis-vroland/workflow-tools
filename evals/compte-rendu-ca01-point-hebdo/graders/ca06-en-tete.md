---
type: llm
focus: { source: file, path: "docs/wf/compte-rendu/2026-10-07-point-hebdo-fieldops.md" }
---

007-CA6 et CA19. Dans l'en-tête du compte rendu, avant la section « Objet » :

- l'outil est nommé (`wf-compte-rendu`) ;
- une date de génération est indiquée ;
- le répertoire n'étant pas un dépôt git avec des commits, l'en-tête indique « hors git » et ne donne aucun hash de commit inventé ;
- la date de la réunion est indiquée au format AAAA-MM-JJ : 2026-10-07 ;
- la source des notes est indiquée par le nom du fichier seul, `2026-10-07-point-hebdo.md`, sans le dossier `notes/` ni aucun autre chemin.

Échoue si l'un de ces points manque.
