# Revue de sécurité de FieldOps

Outil : wf-revue-securite · Date : 2026-10-01 · Commit : 2fc99c0 · Dernier identifiant attribué : S11

> **Document à usage interne.** Il décrit des failles potentiellement non corrigées : il ne doit pas être diffusé hors de l'équipe.

## Synthèse

- Constats : 2 élevé, 2 moyen, 0 faible.
- Dépendances vulnérables : non déterminé (base d'avis injoignable).
- À traiter en priorité : S4, S7.
- Limites : analyse statique de l'état courant du code, sans test d'intrusion, sans exécution du projet, sans analyseur externe et sans recherche dans l'historique git ; elle ne garantit pas l'absence de faille.

## Périmètre et méthode

- Applications analysées :
  - API et back-office web (racine, JavaScript/TypeScript) : OWASP Top 10 (édition 2025)
  - Application compagnon (`mobile/`, Flutter) : OWASP Mobile Top 10 (édition 2024)
- Dossiers analysés : `src/`, `mobile/lib/`.
- Méthode : analyse statique de l'état courant du code, sans test d'intrusion, sans exécution du projet, sans analyseur externe et sans recherche dans l'historique git.

## Dépendances vulnérables

non déterminé (base d'avis injoignable)

## Constats dans le code

### S2 · Requête SQL construite par concaténation

- Application : API et back-office web
- Niveau : moyen
- Catégorie : injection (A05:2025 Injection)
- Emplacement : `src/api/routes/interventions.ts:37`
- Description : l'identifiant de la route est concaténé dans la requête SQL ; la route exige un utilisateur authentifié.
- Recommandation : passer en requête paramétrée.
- Statut : confirmé

### S4 · Suppression d'une intervention sans authentification

- Application : API et back-office web
- Niveau : élevé
- Catégorie : contrôle d'accès (A01:2025 Broken Access Control)
- Emplacement : `src/api/routes/interventions.ts:82`
- Route : `DELETE /api/interventions/:id`
- Description : la route supprime une intervention sans contrôle d'authentification ni d'autorisation.
- Recommandation : ajouter le contrôle d'authentification et restreindre la suppression aux rôles habilités.
- Statut : confirmé

### S7 · Requête SQL construite par concaténation dans les rapports

- Application : API et back-office web
- Niveau : élevé
- Catégorie : injection (A05:2025 Injection)
- Emplacement : `src/api/routes/reports.ts:12`
- Route : `GET /api/reports/:month`
- Description : le mois demandé est concaténé dans la requête SQL, sans authentification.
- Recommandation : passer en requête paramétrée et protéger la route.
- Statut : confirmé

### S9 · Jeton d'accès stocké sans chiffrement

- Application : application compagnon
- Niveau : moyen
- Catégorie : stockage non sécurisé (M9:2024 Insecure Data Storage)
- Emplacement : `mobile/lib/services/auth_service.dart:24`
- Description : le jeton d'accès est enregistré avec `shared_preferences`, stockage non chiffré de l'appareil.
- Recommandation : utiliser un stockage chiffré (trousseau iOS, Keystore Android).
- Statut : confirmé

## Secrets et configuration

aucun constat

## Points non déterminés

- Dépendances vulnérables : base d'avis OSV.dev injoignable, aucune dépendance vérifiée.
