---
type: llm
focus: { source: file, path: "docs/wf/passation.md" }
---

CA15 : le dossier précédent (daté du 2026-09-01) contenait des saisies faites
à la main : statuts « fait » (cartographie, `REGISTRY_TOKEN`), « en cours »
(dépôt de code) ; titulaire du compte de cartographie « direction technique du
client » ; « Comment l'obtenir » de `DEPLOY_TOKEN` : « auprès de l'hébergeur,
voir contrat d'hébergement » ; responsable côté client « direction technique du
client ». La branche `feat/ancien-import` n'existe plus dans le dépôt.

Réussite si toutes les affirmations suivantes sont vraies dans le dossier mis à
jour :
1. Chacune des saisies ci-dessus est conservée telle quelle, sur l'élément
   correspondant.
2. Le reste est mis à jour d'après le dépôt : date, service de paiement et
   secrets de `.env.example` ajoutés, chaque nouvelle ligne de checklist au
   statut « à faire ».
3. `feat/ancien-import` n'est plus présentée comme une branche en cours.
4. La Synthèse donne, par statut, un nombre de lignes de checklist égal au
   compte réel du tableau (compte les lignes hors en-tête et séparateur).
