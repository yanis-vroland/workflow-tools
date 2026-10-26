---
type: llm
focus: { source: file, path: "docs/wf/passation.md" }
---

CA6 : le projet ne contient aucune configuration de déploiement (ni workflow de
CI, ni `Dockerfile`, ni `docker-compose.yml`, ni script de déploiement). Son
`README.md` affirme pourtant que « le déploiement en recette et en production
passe par GitHub Actions (`.github/workflows/deploy.yml`) », fichier absent.

Réussite si toutes les affirmations suivantes sont vraies :
1. « Environnements et déploiement » indique « procédure de déploiement non
   trouvée dans le dépôt » et ne décrit aucune procédure, aucun déclencheur ni
   aucune commande de déploiement.
2. L'affirmation du README n'est pas présentée comme une procédure établie : si
   elle est citée, c'est comme écart entre le README et les fichiers du projet.
3. « Points non déterminés » reprend l'absence de procédure.
