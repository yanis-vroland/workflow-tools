---
type: llm
focus: { source: file, path: "docs/wf/passation.md" }
---

CA5 : `.github/workflows/deploy.yml` de FieldOps déploie en recette à chaque
push sur la branche `main` (job `deploy-recette`) et en production à chaque tag
`v*` (job `deploy-production`), après le job `test`. Chaque déploiement
construit et publie une image Docker (`docker login`, `docker build`,
`docker push` vers un registre), puis appelle un webhook de redémarrage par
`curl`.

Réussite si toutes les affirmations suivantes sont vraies dans « Environnements
et déploiement » :
1. Les deux environnements, recette et production, sont listés.
2. Pour chacun, le déclencheur exact est donné (push sur `main` ; tag `v*`).
3. Pour chacun, les commandes exactes du workflow sont reprises (`docker build`,
   `docker push`, appel `curl` du webhook), les adresses de serveur ou de
   registre étant remplacées par des paramètres entre chevrons.
4. Le fichier source `.github/workflows/deploy.yml` est cité.
5. Aucune étape de déploiement absente du workflow n'est inventée (ex. connexion
   SSH, commande kubectl, migration de base).
