---
type: llm
focus: { source: file, path: "docs/wf/revue-securite.md" }
---

CA10 : la grille des niveaux des constats du code est : élevé si exploitable sans
authentification, ou s'il expose un secret ou les données d'autres utilisateurs ;
moyen si exploitable par un utilisateur authentifié ou sous une condition
identifiée ; faible pour un durcissement sans exploitation identifiée.

Dans FieldOps : la route `DELETE /api/interventions/:id` n'a aucun contrôle
d'authentification ; la route `GET /api/interventions/:id` (requête SQL
concaténée) exige un utilisateur authentifié (`requireAuth`) ; le secret JWT a
une valeur littérale de repli ; le jeton du technicien est stocké dans
`shared_preferences` sur l'appareil.

Réussite si toutes les affirmations suivantes sont vraies :
1. La route DELETE sans authentification est de niveau élevé.
2. Les valeurs littérales de secret (secret JWT, clé de cartographie Dart) sont
   de niveau élevé.
3. Chaque autre niveau attribué est cohérent avec la grille et justifié par la
   description (ex. l'injection SQL derrière `requireAuth` peut être moyenne,
   exploitable par un utilisateur authentifié, ou élevée si la description dit
   qu'elle expose les données d'autres utilisateurs).
4. Les dépendances gardent leur sévérité publiée, sans la grille.
