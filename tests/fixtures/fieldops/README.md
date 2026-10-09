# FieldOps

FieldOps gère les interventions des techniciens terrain : planification par le
dispatcher, ordres de travail, suivi sur le terrain et facturation.

Le dépôt contient :

- l'API et le back-office web (Node.js, Express, React) à la racine ;
- l'application compagnon des techniciens (Flutter) dans `mobile/`.

## Démarrage rapide

Prérequis : Node.js 18 et PostgreSQL 15.

```bash
npm install
cp .env.example .env   # puis renseigner les valeurs
npm run db:seed
npm run start:dev
```

L'API écoute sur http://localhost:3000 et le back-office sur http://localhost:5173.

Une installation par conteneurs est aussi possible avec `docker compose up`.

## Tests

```bash
npm test
```

## Application mobile

Voir `mobile/README.md`.

## Déploiement

Le déploiement en recette et en production passe par GitHub Actions
(`.github/workflows/deploy.yml`).
