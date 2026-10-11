---
name: wf-onboarding
description: Génère ou met à jour docs/wf/onboarding.md, un guide pas à pas qui mène un développeur rejoignant le projet de zéro à sa première contribution (prérequis, installation, lancement, vérification, parcours de lecture du code, conventions, glossaire métier). À utiliser avec /wf-onboarding, ou quand on demande un guide d'onboarding ou de prise en main pour un nouvel arrivant sur le projet courant.
---

# wf-onboarding

Tu rédiges, en français, un guide de prise en main du projet ouvert dans le répertoire courant (le projet cible), pour un développeur qui le rejoint. Le guide répond à « que dois-je faire, dans quel ordre, pour être opérationnel ? ». Il ne décrit pas le système (c'est `wf-doc-projet`) et ne juge pas sa qualité (c'est `wf-analyse-projet`).

## Règles absolues

- **Écriture** : un seul fichier, `docs/wf/onboarding.md`, écrit avec l'outil Write (qui crée `docs/wf/` au besoin ; pas de `mkdir`). Aucun autre fichier du projet n'est créé, modifié, déplacé ou supprimé, y compris le README et les livrables des autres outils dans `docs/wf/`, qui sont seulement lus.
- **Aucune exécution** : tu ne lances ni le projet, ni ses tests, ni son installation, ni aucun de ses outils (npm, npx, yarn, pnpm, node, flutter, fvm, dart, docker, make…). Bash ne sert qu'à `git rev-parse --short HEAD`, `git status --porcelain` et `date +%F`, chacune seule, sans enchaînement. Aucune commande git qui modifie le dépôt. Pour lire, utilise Read, Glob et Grep.
- **Secrets** : ne lis aucun fichier d'environnement (`.env`, `.env.local`, `.env.production`…), sauf `.env.example`, ni avec Read, ni avec Grep, ni avec Bash. Avec Grep, restreins toujours la recherche à des fichiers de code (paramètre `glob`, ex. `*.{ts,tsx,js,jsx,mjs,cjs,vue,dart}`) ou à un dossier de code. Ne recopie aucune valeur de variable, même factice, même tirée de `.env.example`.
- **Données personnelles** : aucune adresse e-mail (de contributeur ou autre) dans le guide.
- **Honnêteté** : chaque affirmation s'appuie sur un fichier lu, dont le chemin (relatif à la racine) est cité. Ce qui n'a pas pu être établi est écrit « non déterminé », jamais deviné.
- **Aucune commande inventée** : une commande n'apparaît dans le guide que si elle figure dans un fichier du projet (script de `package.json`, cible de `Makefile`, `docker-compose.yml`, README, CI…). Seule exception : la commande d'installation des dépendances du gestionnaire de paquets attesté par le manifeste et le fichier de verrouillage (`npm install` pour `package.json` ou `package-lock.json`, `pnpm install` pour `pnpm-lock.yaml`, `yarn install` pour `yarn.lock`, `flutter pub get` pour `pubspec.yaml`), en citant ce fichier. Ne nomme jamais une commande absente des fichiers, même pour signaler son absence : décris l'absence en mots (« aucun script de test dans `package.json` »).
- **Périmètre** : ni schéma d'architecture, ni description des fonctionnalités (une phrase de présentation suffit), ni jugement de qualité, de dette ou de risque (dépendance obsolète, version en fin de support, code non testé, TODO…).

## Étape 1 : vérifier qu'il y a du code source

Avec Glob, cherche des fichiers de code (`.ts`, `.tsx`, `.js`, `.jsx`, `.vue`, `.dart`, `.py`, `.rb`, `.php`, `.go`, `.rs`, `.java`, `.kt`, `.swift`, `.cs`…) ou un manifeste (`package.json`, `pubspec.yaml`, `pyproject.toml`, `requirements.txt`, `go.mod`, `Cargo.toml`, `composer.json`, `Gemfile`, `pom.xml`, `build.gradle`), hors `node_modules/` et dossiers de build.

S'il n'y en a aucun (répertoire vide, ou seulement des documents), n'écris rien, ne crée aucun dossier, et termine par ce message : « Aucun code source trouvé dans ce répertoire : aucun guide n'a été écrit. »

## Étape 2 : préparer l'en-tête

- Date : `date +%F` (format AAAA-MM-JJ).
- Commit : `git rev-parse --short HEAD`. Si la commande échoue (pas un dépôt git), écris « hors git ».
- `git status --porcelain` : si la sortie contient au moins une ligne qui ne concerne pas `docs/wf/onboarding.md`, ajoute la mention « modifications non commitées ». Sinon, ne l'écris pas.
- Stack : JavaScript/TypeScript (`package.json`) et Flutter (`pubspec.yaml`) sont couvertes en v1. Si le projet ne relève d'aucune des deux (ex. Python, PHP, Go), ajoute « stack <nom> non couverte en v1 » et applique la règle « Stack non couverte » plus bas.
- Monorepo : repère chaque application (un manifeste par dossier, ex. `package.json` à la racine et `mobile/pubspec.yaml`) et donne-lui un nom court (ex. « Application web », « Application mobile »).

## Étape 3 : livrable existant

Si `docs/wf/onboarding.md` existe, lis-le d'abord. Tu le réécriras en entier avec Write : un seul guide dans le fichier (jamais l'ancien suivi du nouveau), en conservant ce qui reste vrai d'après les fichiers actuels, en corrigeant ce qui a changé (versions, commandes, chemins) et en mettant à jour la date et le commit. Ne crée aucun autre fichier (pas de copie datée ni numérotée).

Note aussi lequel de ces livrables de `wf-doc-projet` existe : `docs/wf/doc-projet.md`, `docs/wf/doc-projet/index.md`, ou aucun.

## Modèle du livrable

Titres de section en `##`, exactement dans cet ordre, sans table des matières. Sous-sections par application en `###`. Commandes entre accents graves sur la ligne de l'étape, sans bloc de code.

```markdown
# Guide de prise en main de <nom du projet>

Outil : wf-onboarding · Date : AAAA-MM-JJ · Commit : <sha court ou « hors git »>[ · modifications non commitées][ · stack <nom> non couverte en v1]

Ce guide a été établi par lecture des fichiers du projet, sans exécution des commandes : les étapes n'ont donc pas été vérifiées.

<Une phrase de présentation du projet, avec sa source.>

## Avant de commencer

- <Outil> : <version> (`<fichier source>`)
- <Outil> : version non déterminée (requis par `<fichier>`)

## Installer le projet

### <Application> (`<dossier>`)

1. <Action> : `<commande exacte>` (`<fichier source>`)
2. Configurer les variables d'environnement (`.env.example`) : `NOM_1`, `NOM_2`…

Autre voie : <installation par conteneurs ou native>, définie par `<fichier>`.

## Lancer le projet

### <Application> (`<dossier>`)

1. <Action> : `<commande exacte>` (`<fichier source>`)

## Vérifier l'installation

### <Application> (`<dossier>`)

1. Lancer les tests : `<commande exacte>` (`<fichier source>`)

## Se repérer dans le code

1. `<chemin>` : <ce qu'on y apprend>.

## Contribuer

- Nommage des branches : <règle> (`<fichier>`) ou non déterminé.
- Format des commits : <règle> (`<fichier>`) ou non déterminé.
- Lint et format : `<commande>` (`<fichier de script>`, `<fichier de configuration>`).
- Vérifications de CI à passer : <étapes> (`<fichier de CI>`).

## Glossaire métier

- **<Terme>** (`<fichier où il est défini>`) : <définition tirée d'un fichier, ou « définition non déterminée »>.

## Pour aller plus loin

<Renvoi au livrable de wf-doc-projet, ou suggestion de lancer /wf-doc-projet.>

## Points non déterminés

- <Point, avec les fichiers concernés.>
```

## Remplir chaque section

**Avant de commencer** : une ligne par outil requis, toutes applications confondues (en monorepo, une seule liste). Version et fichier source sur la même ligne. Sources de version : `.nvmrc`, `.node-version`, `.tool-versions`, `.fvmrc`, `.fvm/fvm_config.json`, champ `engines` de `package.json`, contrainte `environment` de `pubspec.yaml`, image de `Dockerfile` ou `docker-compose.yml`, README, CI. Si plusieurs fichiers fixent la même version, donne la plus précise et cite les autres comme concordants sur la même ligne ; s'ils se contredisent, signale-le dans « Points non déterminés ». Un outil requis sans version fixée (gestionnaire de paquets, fvm, Docker…) porte « version non déterminée » ; ne déduis jamais une version d'une autre (ex. npm d'après Node.js).

**Installer le projet**, **Lancer le projet**, **Vérifier l'installation** : étapes numérotées, chacune avec une commande exacte et le chemin du fichier d'où elle vient. Une étape qui n'a pas de commande dans les fichiers (configurer une variable, vérifier une route) le dit explicitement : « (étape sans commande) ». En monorepo, une sous-section `###` par application dans chacune des trois sections.
- Une seule voie principale : celle que décrit le README, ou à défaut la voie par conteneurs. L'autre voie tient en une ligne qui cite le fichier qui la définit (ex. `docker-compose.yml`).
- Variables d'environnement : une étape de configuration qui liste leurs noms seulement, tirés de `.env.example` ou, à défaut, du code (`process.env.X`, `import.meta.env.X`, `String.fromEnvironment('X')`, `Platform.environment['X']`). Une commande de copie du modèle n'est donnée que si un fichier du projet la donne.
- Tests : la commande de lancement des tests tirée des fichiers. Sans commande identifiable, écris-le (« aucune commande de test identifiée : non déterminé ») et reprends-le dans « Points non déterminés ».
- Lancement : sans commande identifiable, écris « aucune commande de lancement identifiée : non déterminé » et reprends-le dans « Points non déterminés ».
- README contredit par la configuration (ex. un script cité par le README mais absent de `package.json`) : suis les fichiers de configuration ; la commande du README n'apparaît dans aucune étape, seulement dans « Points non déterminés », avec le chemin du README et celui du fichier qui le contredit.

**Se repérer dans le code** : une seule liste numérotée de 5 à 10 fichiers, même en monorepo, dans l'ordre de lecture conseillé. Le n° 1 est le point d'entrée de l'application principale (ex. `src/main.ts`, `src/api/server.ts`, `lib/main.dart`, celui que lance le script de démarrage) ; enchaîne avec les types du domaine, une route ou un écran représentatif, puis le point d'entrée des autres applications. Chaque fichier : chemin relatif existant, puis une phrase qui dit concrètement ce qu'on y apprend (ex. « comment une requête est validée puis enregistrée »), jamais seulement « fichier représentatif » ni une simple description de l'objet. Si le projet a moins de 5 fichiers de code, complète avec le README et les manifestes.

**Contribuer** : résume les conventions trouvées dans `CONTRIBUTING.md`, la configuration de lint ou de format (`.eslintrc*`, `eslint.config.*`, `.prettierrc*`, `biome.json`, `.editorconfig`, `analysis_options.yaml`…), les hooks git (`.husky/`, `lefthook.yml`, `.pre-commit-config.yaml`, configuration commitlint), la CI (`.github/workflows/*`, `.gitlab-ci.yml`…) et le modèle de PR, en citant chaque fichier : nommage des branches, format des commits, commandes de lint et de format (tirées des scripts), vérifications de CI à passer (ce que la CI exécute, jamais ce qu'elle ne couvre pas). Ne déduis aucune convention de l'historique git ni d'habitudes courantes : un point qu'aucun fichier ne définit est « non déterminé ». Si aucun de ces fichiers n'existe, écris exactement « aucune convention de contribution trouvée dans le dépôt » et reprends-le dans « Points non déterminés ».

**Glossaire métier** : au plus 20 termes, uniquement des noms d'entités, de modèles ou de tables (ex. `Order`, `Customer`, `Invoice`) écrits tels qu'ils sont nommés dans le code ; ni champ, ni option, ni règle de calcul, ni rôle, ni terme technique (framework, bibliothèque, protocole). Une ligne par terme avec le chemin du fichier où il est défini. La définition vient d'un commentaire ou d'une documentation qui porte sur ce terme ; ne la déduis jamais du seul nom du terme ni de ses champs. Sinon, écris exactement « définition non déterminée », sans définition partielle.

**Pour aller plus loin** : liens relatifs depuis `docs/wf/`.
- `docs/wf/doc-projet.md` présent : `[doc-projet.md](doc-projet.md)`, en nommant ses sections « Architecture », « Fonctionnalités » et « Structure du code » comme suite de lecture.
- `docs/wf/doc-projet/index.md` présent : `[index.md](doc-projet/index.md)` (« Architecture »), `[fonctionnalites.md](doc-projet/fonctionnalites.md)` (« Fonctionnalités ») et `[structure.md](doc-projet/structure.md)` (« Structure du code »).
- Aucun des deux : écris qu'aucun livrable de `wf-doc-projet` n'est présent et suggère de lancer `/wf-doc-projet`, sans aucun lien vers un fichier doc-projet.
Tu peux ajouter d'autres documents existants du dépôt (README, specs…), avec leur chemin.

**Points non déterminés** : liste à puces (jamais numérotée) de tout ce qui n'a pas pu être établi : versions, tests, lancement, conventions, écarts entre README et configuration, contradictions entre fichiers, sections non établies. S'il n'y a rien : « - Aucun. »

## Stack non couverte

Projet hors JavaScript/TypeScript et Flutter : en-tête « stack <nom> non couverte en v1 ». Établis les prérequis et les étapes uniquement à partir du README et des fichiers génériques (`Makefile`, `Dockerfile`, `docker-compose.yml`, CI), sans aucune commande propre à un outillage absent de ces fichiers. « Se repérer dans le code » et « Glossaire métier » contiennent « non déterminé (stack <nom> non couverte en v1) », et « Points non déterminés » liste chaque section qui n'a pas pu être établie.

## Fin

Écris le guide avec Write dans `docs/wf/onboarding.md`, puis termine par un message court : chemin du livrable, création ou mise à jour, et nombre de points non déterminés.
