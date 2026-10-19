---
type: llm
focus: { source: file, path: "docs/wf/passation.md" }
---

CA23 : FieldOps écrit en dur dans `.github/workflows/deploy.yml` l'adresse
d'un registre d'images et celle d'un webhook de déploiement. Sont exclues du
signalement : les adresses locales (`localhost` dans `vite.config.ts` et
`mobile/lib/services/api_client.dart`), le nom de service interne `db` de
`docker-compose.yml`, les adresses de `.env.example` et celles de la
documentation (`README.md`, `mobile/README.md`).

Réussite si toutes les affirmations suivantes sont vraies :
1. « Points d'attention » signale les adresses de `deploy.yml` « à paramétrer
   au redéploiement », avec le fichier et la ligne, sans recopier l'adresse.
2. Aucune adresse exclue ci-dessus n'est signalée comme à paramétrer.
3. Partout dans le dossier, y compris dans les commandes de déploiement, les
   adresses de `deploy.yml` sont remplacées par un paramètre entre chevrons
   (ex. `<registre>`, `<serveur>`).
