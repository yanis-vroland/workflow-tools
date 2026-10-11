# workflow-tools

Plugin Claude Code : des outils de workflow pour le quotidien d'un chef de projet et développeur freelance web et mobile. Chaque outil est une skill (`/wf-doc-projet`, `/wf-analyse-projet`…) qu'on lance dans le projet cible, et qui y produit un livrable utilisable tel quel.

> **Statut : en construction.** Aucun outil n'est encore livré.

## Outils prévus

| Famille | Outils |
| --- | --- |
| Comprendre un projet existant | `wf-analyse-projet`, `wf-doc-projet`, `wf-onboarding` |
| Avant-vente et cadrage | `wf-cadrage-besoin`, `wf-chiffrage`, `wf-specs-tickets` |
| Pilotage | `wf-compte-rendu`, `wf-rapport-avancement`, `wf-release-notes` |
| Qualité et livraison | `wf-revue-securite`, `wf-audit-web`, `wf-tests-manquants`, `wf-montee-version`, `wf-recette`, `wf-publication-store`, `wf-passation` |

## Prérequis

- Sources PDF de `wf-cadrage-besoin` : [poppler](https://poppler.freedesktop.org/) (`brew install poppler` sur macOS, paquet `poppler-utils` sous Debian ou Ubuntu). Claude Code s'en sert pour lire un PDF page par page ; sans lui, les PDF sont écartés.

## Fabrication

Ce dépôt est construit avec [agentic-dev-workflow](https://github.com/yanis-vroland/agentic-dev-workflow) : spec validée avant le code, tests d'abord, revue IA en CI, merge humain.

## Licence

[MIT](LICENSE)
