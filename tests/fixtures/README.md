# Fixtures de test

Projets fictifs sur lesquels les evals lancent les outils `wf-*` (ADR-001, section Tests et amendement 1). Toutes les données sont inventées : noms de personnes et de sociétés, adresses e-mail en `@example.invalid`, URL en `.example.invalid`. Aucun livrable produit sur un vrai projet ne doit entrer ici.

| Fixture | Rôle | Outils visés |
|---|---|---|
| `fieldops/` | Monorepo FieldOps volontairement imparfait : API et back-office web JS/TS à la racine, application compagnon Flutter dans `mobile/`, specs internes dans `docs/specs/` | outils de diagnostic et de documentation (001 à 003, 008 à 016, 018) |
| `build-fieldops.sh` | Copie `fieldops/` et y construit un historique git déterministe | outils qui lisent l'historique (001, 008, 009, 012, 014, 016) |
| `build-fieldops-web.sh` | Variante « web seul » : `build-fieldops.sh` puis retrait de `mobile/` dans un commit rejouable ; le projet n'est plus un monorepo | 002 (CA9, CA12) |
| `commit-livrable.sh` | Dépose et commite un livrable existant dans `docs/wf/` d'un FieldOps déjà construit | 002 (CA7, CA12) |
| `fieldops-brief/` | Projet pas encore démarré : brief client, notes d'appel, notes de réunion, transcription. Ni code, ni git | avant-vente et pilotage (004 à 007) |
| `build-pdf.py` | Python 3, bibliothèque standard seule (aucun paquet à installer). Génère un PDF à texte extractible ou un PDF dont le texte est lisible à l'œil mais non extractible, à la manière d'un document scanné (`--no-text`), une page par fichier texte | sources PDF (004-CA4, 004-CA17) |

## Générer un PDF de test

```bash
python3 tests/fixtures/build-pdf.py <destination.pdf> <page1.txt> [<page2.txt> ...]
python3 tests/fixtures/build-pdf.py --no-text <destination.pdf> <page1.txt> [<page2.txt> ...]
```

- Seule la bibliothèque standard de Python 3 est utilisée (`sys`, `unicodedata`) : rien à installer, en local comme en CI.
- Première forme : une page par fichier texte, texte extractible (Helvetica, encodage WinAnsi), pour citer un numéro de page (004-CA4).
- `--no-text` : chaque lettre est dessinée en petits carrés pleins (police matricielle 5 x 7, majuscules sans accents), sans aucun opérateur de texte. Le rendu (`pdftoppm`) montre un texte lisible, `pdftotext` n'en extrait rien : une skill qui lirait le PDF comme une image reprendrait ce texte, ce que l'eval détecte (004-CA17).
- Les textes des pages sont fictifs et fournis par le scaffold de chaque cas (`evals/<cas>/donnees/`).

## Construire FieldOps avec son historique

```bash
bash tests/fixtures/build-fieldops.sh [--dirty] [--no-secret] <destination>
```

- `<destination>` doit être inexistante ou vide.
- Sans option : arbre de travail propre sur `main`, et fichier d'environnement local `.env` (ignoré par `.gitignore`, jamais commité) contenant le marqueur `FIELDOPS_FAUX_SECRET_7f3a`. L'eval vérifie que ce marqueur n'apparaît dans aucun livrable (CA « fichier `.env*` non lu » de chaque spec, ex. 001-CA10, 010-CA17).
- `--dirty` : laisse une modification non commitée dans `src/domain/scheduling.ts` (mention « modifications non commitées » de l'en-tête, ex. 001-CA13, 009-CA24).
- `--no-secret` : ne crée pas le fichier d'environnement.

L'historique est rejouable : deux exécutions produisent les mêmes hash de commits (auteurs, dates et configuration git fixés, configuration de la machine ignorée). Après le dernier commit de `main`, l'arbre de travail est exactement le contenu de `fieldops/`.

Contenu de l'historique :

- 42 commits sur `main` du 2025-08-04 au 2026-09-29, 4 auteurs fictifs (`@example.invalid`), messages Conventional Commits en français ;
- tags annotés `v1.0.0` (2025-12-05), `v1.1.0` (2026-04-08), `v1.2.0` (2026-08-05) ;
- branche fusionnée `feat/T07-planning` (commit de fusion, puis branche supprimée) et tickets `T03`, `T07` cités dans des messages ;
- branche non fusionnée `feat/export-pdf` : 3 commits du 2026-09-24 au 2026-09-30, dont `feat(export): export PDF des interventions` puis `fix(export): marge du PDF des interventions` ;
- un commit et son `revert` (notification SMS), un changement cassant `feat(invoice)!` avec `BREAKING CHANGE:`, un commit hors convention (`corrections diverses avant démo`) ;
- points chauds : `src/api/routes/interventions.ts` (9 commits, non testé), `src/domain/invoice.ts` (6 commits, testé), `mobile/lib/screens/intervention_list_screen.dart` (5 commits, non testé).

## Défauts volontaires de `fieldops/`

Les références `NNN-CAn` renvoient aux specs `docs/specs/` de ce dépôt.

### Application web (racine)

| Défaut | Fichier | CA visés |
|---|---|---|
| `react` et `react-dom` 17, `@types/react` 17 : au moins une version majeure de retard ; `express` 4 | `package.json`, `package-lock.json` | 001-CA3, 013-CA3, 013-CA10 |
| Node.js 18 (fin de support) fixé à trois endroits | `.nvmrc`, `package.json` (`engines`), `Dockerfile` | 003-CA3, 013-CA4, 013-CA6 |
| README qui annonce `npm run start:dev`, absent des scripts | `README.md` | 002-CA13, 003-CA20, 016-CA13 |
| Installation par conteneurs et installation native | `docker-compose.yml`, `README.md` | 003-CA7 |
| Requête SQL concaténée (`"SELECT * FROM interventions WHERE id = " + req.params.id`) | `src/api/routes/interventions.ts` l. 37 | 010-CA12 |
| Route `DELETE /api/interventions/:id` sans authentification | `src/api/routes/interventions.ts` l. 82 | 010-CA13 |
| Valeur littérale de repli pour `JWT_SECRET` | `src/api/middleware/auth.ts` l. 6 | 010-CA14 |
| CORS ouvert, aucun en-tête de sécurité ni CSP | `src/api/server.ts` | 010-CA9, 010-CA11, 011 (bonnes pratiques) |
| Jeton d'accès dans `localStorage` | `src/web/api.ts` | 010 |
| `<html>` sans `lang`, pas de `<title>` | `src/web/index.html` | 011-CA8, 011-CA9 |
| Images sans `alt` | `src/web/index.html` l. 10, `src/web/pages/InterventionList.tsx` l. 34 | 011-CA6 |
| Champs sans libellé (`input` avec `placeholder` seul, `select`) | `src/web/pages/NewIntervention.tsx` l. 25, `src/web/pages/InterventionList.tsx` l. 23 | 011-CA7 |
| Module testé avec branches non couvertes (montant négatif, remise fidélité) | `src/domain/invoice.ts` + `src/domain/invoice.test.ts` | 001-CA5, 012-CA6, 012-CA13 |
| Modules non testés : point chaud non couvert, module à branches conditionnelles | `src/api/routes/interventions.ts`, `src/domain/scheduling.ts` | 001-CA5, 001-CA7, 012-CA9, 012-CA10 |
| Fichier de types sans logique | `src/domain/types.ts` | 012-CA12 |
| 15 marqueurs `TODO`, `FIXME`, `HACK` répartis dans 13 fichiers (web et mobile) | ex. `src/api/routes/interventions.ts`, `Dockerfile` | 016-CA12 |
| Rôles `admin`, `dispatcher`, `technician` et données de démonstration, mot de passe lu dans une variable | `src/db/seed.ts`, `src/db/schema.sql` | 014-CA15 |
| Services tiers repérés par variables : cartographie, e-mail transactionnel, paiement | `.env.example`, `src/services/*.ts` | 003-CA6, 016-CA7 |
| Déploiement recette (branche `main`) et production (tags), secrets `REGISTRY_TOKEN`, `DEPLOY_TOKEN` | `.github/workflows/deploy.yml`, `Dockerfile`, `docker-compose.yml` | 016-CA5, 016-CA8 |
| Lint configuré, CI, Vitest | `.eslintrc.json`, `.github/workflows/deploy.yml`, `package.json` | 003-CA9, 012-CA3, 013-CA16 |
| Tâche planifiée : workflow de CI programmé (`schedule`, cron `30 2 * * *`, plus `workflow_dispatch`) qui lance la purge des interventions clôturées depuis plus de 24 mois ; secret `PRODUCTION_DATABASE_URL` | `.github/workflows/purge.yml`, `src/jobs/purge-closed-interventions.ts` | 018-CA6 |
| Obligation non automatisée : date d'expiration de la clé de cartographie (`MAP_API_KEY_EXPIRES_AT`), lue par le client de cartographie qui désactive le géocodage une fois la clé expirée (`console.warn`) | `.env.example`, `src/services/mapClient.ts` | 018-CA8, 018-CA15 |
| Exploitation : sortie standard et d'erreur seules (`console.log`, `console.warn`), aucune journalisation des requêtes, route `/api/health`, `docker-compose.yml` sans clé `restart`, redémarrage distant par webhook | `src/api/server.ts`, `docker-compose.yml`, `.github/workflows/deploy.yml` | 018-CA4, 018-CA5, 018-CA10, 018-CA13, 018-CA14 |
| Domaine métier : `Intervention`, `Technician`, `WorkOrder` | `src/domain/types.ts`, `src/db/schema.sql` | 003-CA11 |

### Application compagnon Flutter (`mobile/`)

| Défaut | Fichier | CA visés |
|---|---|---|
| Monorepo : application Flutter dans un sous-dossier | `mobile/pubspec.yaml` | 003-CA21, 010-CA24, 011-CA21, 012-CA23, 013-CA27, 015-CA3, 016-CA20 |
| `http` 0.13, `geolocator` 9, `flutter_lints` 2 : versions majeures de retard ; Flutter 3.13 fixé | `mobile/pubspec.yaml`, `mobile/pubspec.lock`, `mobile/.fvmrc` | 013-CA3, 013-CA5 |
| Version `1.2.0+14` avec numéro de build | `mobile/pubspec.yaml` | 009-CA7, 015-CA6 |
| `rawQuery` interpolée (`WHERE id = $id`) avec `sqflite` | `mobile/lib/db/local_db.dart` l. 33 | 010-CA12 |
| Jeton stocké dans `shared_preferences` | `mobile/lib/services/auth_service.dart` l. 24 | 010-CA15 |
| Fichier généré | `mobile/lib/models/intervention.g.dart` | 012-CA12 |
| Un seul fichier de test (couverture partielle) | `mobile/test/duration_format_test.dart` | 012-CA4, 012-CA6 |
| Permissions localisation et caméra, `targetSdkVersion 33`, `minSdkVersion 21` | `mobile/android/app/src/main/AndroidManifest.xml`, `mobile/android/app/build.gradle` | 015-CA9, 015-CA15 |
| Build `release` signé avec la configuration `debug` | `mobile/android/app/build.gradle` l. 31 | 015-CA11 |
| `NSCameraUsageDescription` vide ; `NSPhotoLibraryUsageDescription` absente alors que la galerie est utilisée | `mobile/ios/Runner/Info.plist`, `mobile/lib/screens/intervention_detail_screen.dart` l. 39 | 015-CA8, 015-CA10 |
| Aucune icône (`mipmap-*`, `AppIcon.appiconset`), aucune métadonnée de store | `mobile/android/`, `mobile/ios/` | 015-CA8, 015-CA9, 015-CA18 |

### Specs internes (`docs/specs/`)

| Élément | Fichier | CA visés |
|---|---|---|
| Specs validées à critères numérotés | `docs/specs/001-interventions.md`, `docs/specs/002-ordres-de-travail.md` | 014-CA4 |
| Spec au statut « brouillon » | `docs/specs/003-export-pdf.md` | 014-CA13 |
| Routes sans spec : `/api/technicians`, `/api/auth/login` | `src/api/routes/technicians.ts`, `src/api/routes/auth.ts` | 014-CA12 |

## Défauts volontaires de `fieldops-brief/`

| Élément | Fichier | CA visés |
|---|---|---|
| Répertoire sans code source ni git | tout le dossier | 004-CA21, 005-CA22, 006-CA15, 007-CA19 |
| Qualificatifs non quantifiés : « beaucoup d'interventions », « rapide », « intuitive » | `brief-fieldops.md` | 004-CA6 |
| Contradiction : outil web sans installation sur les téléphones (brief) contre application mobile hors connexion (notes d'appel) | `brief-fieldops.md`, `notes-appel.md` | 004-CA8 |
| Exclusion explicite : la facturation | `brief-fieldops.md`, `notes-appel.md` | 004-CA9 |
| Priorités exprimées pour certains besoins seulement | `brief-fieldops.md` | 004-CA5 |
| Adresses e-mail fictives (`@example.invalid`) et numéro de téléphone factice | `brief-fieldops.md`, `notes/2026-10-07-point-hebdo.md` | 004-CA19, 007-CA11 |
| Informations absentes : hébergement, date de mise en production précise, budget | `brief-fieldops.md`, `notes-appel.md` | 004-CA23 |
| Notes brutes datées : participants avec rôles, décisions, actions avec responsable et échéance, action sans échéance | `notes/2026-10-07-point-hebdo.md` | 007-CA1, 007-CA3, 007-CA5, 007-CA7 |
| Proposition sans accord (« Proposition : passer l'export PDF en tâche de fond… ») | `notes/2026-10-07-point-hebdo.md` | 007-CA8 |
| Question en suspens (reprise de l'historique du tableur) | `notes/2026-10-07-point-hebdo.md` | 007-CA5, 008-CA13 |
| Responsable ambigu (« il faut qu'il relance… ») | `notes/2026-10-07-point-hebdo.md` | 007-CA20 |
| Mot de passe factice du compte de recette | `notes/2026-10-07-point-hebdo.md` | 007-CA12 |
| Transcription WebVTT horodatée avec tours de parole | `notes/2026-09-30-atelier.vtt` | 007-CA13 |

## Limites connues

- Pas d'image de plus de 200 Ko ni d'icône réelle : la fixture ne contient aucun binaire (011-CA10 non déclenché).
- Les versions intermédiaires des points chauds sont des troncatures du fichier final : elles ne compilent pas toutes, ce qui est sans effet pour les outils qui ne lisent que l'historique.
- Aucun fichier `.env*` versionné dans la fixture : les CA qui le supposent le créent dans le scaffold de leur cas (010-CA16 : `.env.staging` suivi par git, dans `evals/revue-securite-ca08-ca16-base-injoignable/`) ou demandent une fixture dédiée (008-CA18).
