# Analyse du projet

Outil : wf-analyse-projet · Date : 2026-10-08 · Commit analysé : 2fc99c0

## Synthèse

Monorepo : API et back-office web TypeScript à la racine, application compagnon Flutter dans `mobile/`. Principaux risques : une requête SQL concaténée et une signature de build mobile incorrecte.

## Stack et dépendances

- `react` : installée 17.0.2 (`package-lock.json`), retard majeur.

## Architecture

### Application web (`.`)

API Express dans `src/api/`, back-office React dans `src/web/`, domaine dans `src/domain/`.

### Application mobile (`mobile/`)

Application Flutter, point d'entrée `mobile/lib/main.dart`.

## Activité du dépôt

- Fichiers les plus modifiés sur 12 mois : `src/api/routes/interventions.ts` (9 commits).

## Qualité et tests

Fichiers source non couverts : `src/api/routes/interventions.ts`, `src/domain/scheduling.ts`.

## Sécurité

Requête SQL construite par concaténation (`src/api/routes/interventions.ts`).

## Dette et risques

- **élevé** : requête SQL construite par concaténation dans la route de détail des interventions, injection possible ; fichier le plus modifié et non testé (`src/api/routes/interventions.ts`).
- **élevé** : build `release` de l'application mobile signé avec la configuration `debug` (`mobile/android/app/build.gradle`).
- **moyen** : `react` et `react-dom` 17, une version majeure de retard (`package.json`).
- **faible** : fichier de types sans test dédié (`src/domain/types.ts`).

## Effort de reprise

Effort **moyen** : voir les deux risques élevés ci-dessus.

## Points non déterminés

- Hébergement de production : non déterminé.
