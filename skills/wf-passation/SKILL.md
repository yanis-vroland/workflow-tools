---
name: wf-passation
description: Génère ou met à jour docs/wf/passation.md, le dossier de passation de fin de mission destiné à la personne qui reprend le projet (équipe du client ou autre prestataire) — documentation de référence, environnements et procédure de déploiement, services tiers et titulaires des comptes, secrets à transmettre (sans valeur), travaux en cours, points d'attention factuels et checklist de passation à statuts. À utiliser avec /wf-passation, ou quand on demande un dossier de passation, de transfert ou de réversibilité du projet courant.
---

# wf-passation

Tu rédiges, en français, le dossier de passation du projet ouvert dans le répertoire courant (le projet cible). Il s'adresse au repreneur, qui devient responsable du projet, et répond à la question : « que dois-je recevoir et savoir pour assumer ce projet seul ? ». Le dossier est unique et neutre : le même vaut pour un client comme pour un autre prestataire.

Il ne décrit pas le système (stack, architecture, installation locale : c'est `wf-doc-projet`, auquel il renvoie), ne guide pas un nouvel arrivant (c'est `wf-onboarding`) et ne porte aucun jugement (dette, risque, effort de reprise : c'est `wf-analyse-projet`, dont il ne reprend rien).

## Règles absolues

- **Écriture** : un seul fichier, `docs/wf/passation.md`, écrit avec l'outil Write (qui crée `docs/wf/` au besoin ; pas de `mkdir`). Aucun autre fichier du projet n'est créé, modifié, déplacé ou supprimé, y compris le README et les livrables des autres outils dans `docs/wf/`, qui sont seulement lus.
- **Aucune exécution, aucune récupération distante** : tu ne lances ni le projet, ni ses tests, ni son installation, ni son déploiement, ni aucun de ses outils (npm, npx, yarn, pnpm, node, flutter, dart, python, pip, docker, flyctl, make…). Tu ne récupères aucune référence distante (pas de fetch, pull, ls-remote ni remote update) et tu ne consultes aucune plateforme (PR, issues, tickets). Bash ne sert qu'aux commandes ci-dessous, recopiées telles quelles, chacune seule, sans guillemets, redirection, variable, sous-shell ni enchaînement (`&&`, `;`, `|`) :
  - `date +%F`
  - `git rev-parse --short HEAD`
  - `git status --porcelain`
  - `git symbolic-ref refs/remotes/origin/HEAD`
  - `git show-ref --verify refs/heads/main`
  - `git show-ref --verify refs/heads/master`
  - `git branch -a --no-merged <principale>`
  - `git rev-list --count <principale>..<branche>`
  - `git log -1 --format=%cs <branche>`

  Aucune autre commande Bash, même en lecture (`ls`, `cat`, `find`, `grep`, `git log` avec un autre format…). Pour lire, utilise Read, Glob et Grep.
- **Secrets** : ne lis jamais, ni avec Read, ni avec Grep, ni avec Bash, un fichier d'environnement (`.env`, `.env.local`, `.env.production`…, sauf `.env.example`) ni un fichier de secrets ou d'identifiants (`.envrc`, `.npmrc`, `android/key.properties`, `*.keystore`, `*.jks`, `*.pem`, `*.p12`, `credentials*.json`, `service-account*.json`). Avec Grep, passe toujours le paramètre `glob` limité à des extensions de code ou de configuration (voir « Recherches »), jamais un dossier seul : un dossier peut contenir un fichier d'environnement. Ne recopie aucune valeur de secret, de variable d'environnement ou d'identifiant, même factice, même tirée de `.env.example` : seulement leurs noms.
- **Données personnelles** : aucune adresse e-mail (de contributeur ou autre) et aucun nom de personne dans le dossier. N'utilise jamais un format git qui affiche un auteur. Les interlocuteurs sont désignés par leur rôle (responsable côté client, prestataire sortant, repreneur), avec le champ « à compléter ».
- **Adresses en dur** : aucune adresse IP ni aucun nom de domaine du projet n'est recopié dans le dossier, même dans une commande : chacune est remplacée par un paramètre entre chevrons qui dit son rôle (`<serveur>`, `<registre>`, `<webhook>`, `<api>`…). Voir « Adresses à paramétrer au redéploiement ».
- **Honnêteté** : chaque affirmation s'appuie sur un fichier lu, dont le chemin (relatif à la racine) est cité. Ce qui n'a pas pu être établi est écrit « non déterminé » ou « à compléter », jamais deviné. Aucune procédure, commande ou démarche n'est inventée (ni pour déployer, ni pour obtenir un secret, ni pour transférer un compte).
- **Faits, pas de jugement** : aucun niveau de risque, de gravité ou de priorité, aucune note ni aucun score, aucune estimation d'effort ou de délai.
- **Aucune question** : tu ne poses aucune question pendant l'exécution ; ce qui manque devient « à compléter ».

## Recherches

- Grep sur le code et la configuration : `glob` `**/*.{ts,tsx,js,jsx,mjs,cjs,vue,svelte,dart,py,rb,php,go,rs,java,kt,kts,swift,cs,gradle,yml,yaml,toml,json,xml,plist,sh,sql,html}`, et un second Grep avec `glob` `**/{Dockerfile,Dockerfile.*,Makefile,Procfile}` pour les fichiers sans extension. Ignore les résultats sous `node_modules/`, `dist/`, `build/`, `.dart_tool/`, `docs/`, les fichiers de verrouillage (`package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`, `pubspec.lock`, `poetry.lock`…) et les fichiers générés (`*.g.dart`, `*.freezed.dart`, `*.min.js`).
- Les dossiers cachés (`.github/`, `.gitlab/`, `.circleci/`) peuvent échapper à Grep : trouve les fichiers de CI avec Glob (`.github/workflows/*.yml`, `.github/workflows/*.yaml`, `.gitlab-ci.yml`, `.circleci/config.yml`, `bitbucket-pipelines.yml`, `azure-pipelines.yml`) et lis-les en entier avec Read, qui donne les numéros de ligne.

## Étape 1 : vérifier qu'il y a du code source

Avec Glob, cherche des fichiers de code (`.ts`, `.tsx`, `.js`, `.jsx`, `.vue`, `.dart`, `.py`, `.rb`, `.php`, `.go`, `.rs`, `.java`, `.kt`, `.swift`, `.cs`…) ou un manifeste (`package.json`, `pubspec.yaml`, `pyproject.toml`, `requirements.txt`, `go.mod`, `Cargo.toml`, `composer.json`, `Gemfile`, `pom.xml`, `build.gradle`), hors `node_modules/` et dossiers de build.

S'il n'y en a aucun (répertoire vide, ou seulement des documents), n'écris rien, ne crée aucun dossier, et termine par ce message : « Aucun code source trouvé dans ce répertoire : aucun dossier de passation n'a été écrit. »

## Étape 2 : préparer l'en-tête

- Date : `date +%F` (format AAAA-MM-JJ).
- Commit : `git rev-parse --short HEAD`. Si la commande échoue (pas un dépôt git, ou dépôt sans commit), écris « hors git » et ne lance plus aucune commande git.
- `git status --porcelain` (dépôt git seulement) : si la sortie contient au moins une ligne qui ne concerne pas `docs/wf/passation.md`, ajoute la mention « modifications non commitées » et garde la liste de ces fichiers pour « Travaux en cours ». Sinon, ne l'écris pas.
- Stack : JavaScript/TypeScript (`package.json`) et Flutter (`pubspec.yaml`) sont couvertes en v1. Si le projet ne relève d'aucune des deux (ex. Python, PHP, Go), ajoute « stack <nom> non couverte en v1 » et applique « Stack non couverte » plus bas.
- Applications : repère chaque application (un manifeste par dossier, ex. `package.json` à la racine et `<dossier>/pubspec.yaml`) et donne-lui un nom court tiré de son manifeste, de son dossier ou du README, suivi de son dossier (ex. « Application web (racine) », « Application mobile (`<dossier>/`) »). S'il y en a plusieurs, c'est un monorepo : « Environnements et déploiement » et « Services tiers et accès » ont une sous-section `###` par application.

## Étape 3 : livrables existants

- Si `docs/wf/passation.md` existe, lis-le d'abord et relève les **saisies humaines** (amendement 1 de l'ADR-001), élément par élément :
  - le Statut de chaque ligne de la checklist, rattaché à son élément (service, secret, dépôt de code, branche) ;
  - tout champ qui ne vaut plus « à compléter » : titulaire du compte de chaque service, colonne « Comment l'obtenir » de chaque secret, chaque interlocuteur de la Synthèse ; et la colonne « Utilisé pour » quand le code ne l'établit pas.

  Tu le réécriras en entier avec Write : un seul dossier dans le fichier (jamais l'ancien suivi du nouveau), sans autre fichier (pas de copie datée ni numérotée). Pour chaque élément dont la source existe toujours, recopie ces saisies telles quelles, au mot près ; tout le reste est établi à nouveau d'après les fichiers actuels (date, commit, environnements, éléments nouveaux au statut « à faire »…). Un élément dont la source a disparu (branche supprimée, secret ou service qui n'est plus référencé) sort du dossier et de la checklist ; « Points non déterminés » le signale avec la saisie qu'il portait (ex. « ligne retirée : branche `<nom>` introuvable, statut saisi « … » »).
- Relève les livrables des autres outils présents dans `docs/wf/` (Glob `docs/wf/*.md` et `docs/wf/*/index.md`), en particulier le livrable de `wf-doc-projet` : `docs/wf/doc-projet.md` (fichier unique), `docs/wf/doc-projet/index.md` (format dossier), ou aucun. Ils sont seulement lus, pour y renvoyer ; tu n'en recopies pas le contenu.

## Modèle du livrable

Titres de section en `##`, exactement dans cet ordre, sans table des matières. Sous-sections en `###`. Les crochets `[…]` marquent ce qui est facultatif.

```markdown
# Dossier de passation de <nom du projet>

Outil : wf-passation · Date : AAAA-MM-JJ · Commit : <sha court ou « hors git »>[ · modifications non commitées][ · stack <nom> non couverte en v1]

Ce dossier a été établi par lecture des fichiers du projet, sans exécution ni accès aux plateformes distantes. Les champs « à compléter » et la colonne Statut de la checklist se remplissent à la main : ils sont conservés quand l'outil est relancé.

## Synthèse

- Périmètre transmis : <application> (`<dossier>`), <application> (`<dossier>`).
- Commit de référence : `<sha court>` (ou « hors git »).
- Checklist de passation : <total> lignes, dont <n> « à faire »[, <n> « en cours »][, <n> « fait »].
- Interlocuteurs :
  - Responsable du projet côté client : à compléter
  - Prestataire sortant : à compléter
  - Repreneur : à compléter

## Documentation de référence

- [<titre>](<lien relatif depuis docs/wf/>) : <ce qu'on y trouve>.

## Environnements et déploiement

### <Application> (`<dossier>`)

- **<Environnement>** : déclencheur : <déclencheur exact> (`<fichier>`).
  1. `<commande exacte, adresses remplacées par des paramètres>` (`<fichier>` l. <n>)

## Services tiers et accès

### <Application> (`<dossier>`)

- **<Service>** : indice : <ce qui l'établit> (`<fichier>`) · titulaire du compte : à compléter

## Secrets à transmettre

Valeurs à transmettre par un canal sécurisé, hors de ce document.

| Secret | Utilisé pour | Référencé dans | Comment l'obtenir |
|---|---|---|---|
| `<NOM>` | <usage> (`<fichier>`) ou à compléter | `<fichier>` | <service> (`<fichier>`) ou à compléter |

## Travaux en cours

Branche principale : `<nom>` (<comment elle a été déterminée>). L'état des branches distantes est celui de la dernière récupération faite sur ce poste : l'outil n'interroge pas le dépôt distant.

| Branche | Dernier commit | Commits d'avance |
|---|---|---|
| `<branche>` | AAAA-MM-JJ | <n> |

Modifications non commitées : <fichiers> (ou « aucune »).

## Points d'attention

### Marqueurs TODO, FIXME, HACK

<total> marqueurs au total, dans <n> fichiers :

| Fichier | Marqueurs |
|---|---|
| `<fichier>` | <n> |

### Écarts entre README et code

- <écart, avec les deux fichiers cités>

### Tests désactivés

- `<fichier>` l. <n> : <test désactivé>

### Adresses à paramétrer au redéploiement

- `<fichier>` l. <n>, <n> : <rôle de l'adresse> (<paramètre>) : à paramétrer au redéploiement.

## Checklist de passation

| Action | Source | Statut |
|---|---|---|
| Transférer l'accès au service <service> | `<fichier>` | à faire |
| Transmettre le secret `<NOM>` | `<fichier>` | à faire |
| Transférer les droits sur le dépôt de code | dépôt git | à faire |
| Fusionner, abandonner ou transmettre la branche `<branche>` | git | à faire |

## Points non déterminés

- <Point, avec les fichiers concernés.>
```

## Remplir chaque section

**Synthèse** : rédigée en dernier. Le périmètre transmis nomme chaque application du dépôt avec son dossier. Le commit de référence est celui de l'en-tête. Compte les lignes du tableau final de la checklist par valeur de Statut (une saisie humaine comme « fait » ou « abandonnée » est un statut à part entière) : les nombres annoncés, total compris, sont exactement ceux du tableau ; recompte avant d'écrire. Les interlocuteurs sont des rôles, jamais des noms ; chacun vaut « à compléter » sauf saisie conservée.

**Documentation de référence** : liens Markdown relatifs au dossier `docs/wf/` (ex. `[README.md](../../README.md)`, `[<dossier>/README.md](../../<dossier>/README.md)`, `[docs/specs/](../specs/)`, `[onboarding.md](onboarding.md)`), jamais de chemin absolu.
- Documentation propre du projet : chaque README (racine et applications), `CONTRIBUTING.md`, `CHANGELOG.md`, et les documents de `docs/` hors `docs/wf/` (un lien par fichier, ou un lien par dossier s'il en contient plus de cinq).
- Livrables `wf-*` présents dans `docs/wf/` (ex. `docs/wf/onboarding.md`, `docs/wf/exploitation.md`, `compte-rendu/index.md`), chacun par un lien relatif, sauf les livrables à usage interne : `analyse-projet`, `chiffrage` et `revue-securite` n'y figurent jamais, ni par un lien, ni par leur nom. Ne liste pas `passation.md` lui-même.
- Livrable de `wf-doc-projet` présent en fichier unique (`docs/wf/doc-projet.md`) : `[doc-projet.md](doc-projet.md)`, en nommant ses sections « Stack technique », « Architecture », « Installation et lancement » et « Configuration » comme référence pour décrire le système.
- Présent en format dossier (`docs/wf/doc-projet/index.md`) : `[index.md](doc-projet/index.md)` pour « Stack technique » et « Architecture », `[installation.md](doc-projet/installation.md)` pour « Installation et lancement », `[configuration.md](doc-projet/configuration.md)` pour « Configuration ».
- Aucun des deux : écris qu'aucun livrable de `wf-doc-projet` n'est présent, que la description du système (stack, architecture, installation) n'est donc pas disponible, et suggère de lancer `/wf-doc-projet`, sans aucun lien vers un fichier doc-projet.
- Dans tous les cas, la passation ne décrit ni la stack (langages, frameworks, versions) ni l'architecture.

**Environnements et déploiement** : cherche les configurations de déploiement : workflows de CI avec une étape de déploiement (`.github/workflows/*`, `.gitlab-ci.yml`…), `Dockerfile`, `docker-compose*.yml`, `vercel.json`, `netlify.toml`, `fly.toml`, `firebase.json`, `app.yaml`, `Procfile`, `render.yaml`, cibles de `Makefile` et scripts de déploiement (`deploy*.sh`, scripts `deploy` de `package.json`), configuration de publication mobile (`fastlane/`, `codemagic.yaml`).
- Un environnement est établi par un fichier : `environment:` d'un job, nom de job ou de cible, branche ou tag déclencheur, fichier de configuration propre à un environnement. Pour chacun : son nom tel qu'il figure dans le fichier, le déclencheur exact (ex. push sur `<branche>`, tag `<motif>`, lancement manuel, commande), et les commandes recopiées telles qu'elles figurent dans le fichier, dans l'ordre, avec le fichier et la ligne. Dans ces commandes, une adresse écrite en dur est remplacée par son paramètre (`<registre>`, `<serveur>`…) ; une référence de secret (`${{ secrets.<NOM> }}`) ou de variable de CI reste telle quelle (ce n'est pas une valeur) ; une valeur de variable d'environnement est remplacée par `<NOM>`.
- Un `Dockerfile` ou un `docker-compose*.yml` qui ne sert qu'à construire ou lancer localement ne définit pas un environnement : cite-le seulement s'il est utilisé par une procédure de déploiement établie (ex. image construite par la CI).
- Aucune configuration de déploiement identifiable (pour le projet, ou pour une application d'un monorepo) : écris exactement « procédure de déploiement non trouvée dans le dépôt », reprends-le dans « Points non déterminés », et n'invente aucune procédure, aucune commande ni aucun déclencheur, même si un README en affirme une : une telle affirmation sans fichier correspondant est un écart entre README et code (« Points d'attention »).

**Services tiers et accès** : un service tiers est repéré par au moins un indice, cité avec son fichier :
- une dépendance (SDK) d'un manifeste couvert : `package.json` (ex. `stripe`, `@sentry/*`, `firebase`, `@aws-sdk/*`, `twilio`, `@sendgrid/*`, `@supabase/*`, `algoliasearch`) ou `pubspec.yaml` (ex. `firebase_*`, `sentry_flutter`, `google_maps_flutter`, `onesignal_flutter`) ;
- un fichier de configuration (ex. `firebase.json`, `google-services.json`, `GoogleService-Info.plist`, `sentry.properties`, `vercel.json`, `netlify.toml`, `fly.toml`) ou un fichier de CI (registre d'images, service appelé pour déployer) ;
- un nom de variable d'environnement de `.env.example` ou lu par le code (ex. `<SERVICE>_API_KEY`, `<SERVICE>_API_URL`), avec le client qui l'utilise dans le code s'il existe.

Nomme le service par ce que les fichiers établissent (nom du SDK, nom de la plateforme, ou rôle décrit par un commentaire, ex. « service de cartographie ») ; ne nomme jamais un fournisseur que rien ne cite. Chaque service porte exactement « titulaire du compte : à compléter » (sauf saisie conservée). En monorepo, une sous-section par application ; une application sans indice porte « Aucun service tiers identifié. ». Ne recopie aucune valeur (URL, clé).

**Secrets à transmettre** : la mention « Valeurs à transmettre par un canal sécurisé, hors de ce document. » précède le tableau `| Secret | Utilisé pour | Référencé dans | Comment l'obtenir |`, une ligne par secret, jamais de valeur.
- Secrets de CI : chaque référence `${{ secrets.<NOM> }}` des workflows, ou variable protégée équivalente d'une autre CI ; `GITHUB_TOKEN`, fourni automatiquement par la plateforme, n'est pas un secret à transmettre.
- Secrets de `.env.example` : chaque variable dont le nom désigne un secret (contient `KEY`, `SECRET`, `TOKEN`, `PASSWORD`, `PASSWD`, `PRIVATE` ou `CREDENTIAL`) et chaque chaîne de connexion dont la valeur d'exemple porte un identifiant et un mot de passe (`<protocole>://<utilisateur>:<mot de passe>@…`). Ne recopie jamais la valeur d'exemple.
- « Référencé dans » : le ou les fichiers qui le référencent (workflow, `.env.example`, `docker-compose.yml`…).
- « Utilisé pour » : établi par l'usage du secret dans le code ou la CI (Grep de son nom, ou ligne du workflow qui l'emploie), avec le fichier cité (ex. « authentification auprès du registre d'images (`<workflow>` l. <n>) ») ; sinon « à compléter ».
- « Comment l'obtenir » : nomme le service qui délivre la valeur seulement quand le code l'établit (SDK ou API d'un service identifié dans « Services tiers et accès », auquel le secret est envoyé), avec le fichier ; sinon « à compléter ». Un secret propre au projet (clé de signature de jetons, mot de passe de base, de données de démonstration) n'est délivré par aucun service : « à compléter ». Aucune procédure n'est inventée (ni commande de génération, ni console, ni démarche).

**Travaux en cours** :
- Hors git : écris « non applicable (hors git) », sans tableau.
- Branche principale : `git symbolic-ref refs/remotes/origin/HEAD` ; si elle répond `refs/remotes/origin/<nom>`, la principale est `origin/<nom>` (« déterminée par origin/HEAD »). Sinon `git show-ref --verify refs/heads/main`, puis `git show-ref --verify refs/heads/master` : la première qui réussit donne la principale (« branche main présente », « branche master présente »).
- Aucune des trois : écris « branche principale non déterminée (ni origin/HEAD, ni branche main ou master) », reprends-le dans « Points non déterminés », ne lance aucune autre commande de branche, ne déclare aucune branche non fusionnée et ne donne aucun nombre de commits d'avance. Ne suppose jamais qu'une autre branche est la principale.
- Sinon `git branch -a --no-merged <principale>` : chaque ligne est une branche (retire `* ` et les espaces de tête ; ignore les lignes qui contiennent `->` et la principale elle-même ; garde le préfixe `remotes/` des branches distantes). Pour chacune : `git log -1 --format=%cs <branche>` (date du dernier commit) et `git rev-list --count <principale>..<branche>` (commits d'avance). Une ligne du tableau par branche ; sans branche, « Aucune branche non fusionnée. ».
- Toujours, en dépôt git, la phrase sur la dernière récupération faite sur ce poste (voir le modèle), et les modifications non commitées relevées à l'étape 2, fichier par fichier (au plus 20, puis « et <n> autres »), ou « aucune ».

**Points d'attention** : uniquement des faits vérifiables, chacun avec son fichier. Une sous-section sans élément porte « Aucun. ».
- Marqueurs : Grep du motif `\b(TODO|FIXME|HACK)\b` (sensible à la casse) avec `output_mode` `count`, sur les globs de « Recherches », plus les fichiers de CI lus. Donne le total de marqueurs, puis au plus 20 fichiers, triés par nombre de marqueurs décroissant (à égalité, par chemin), chacun avec son nombre. Ne commente pas le contenu des marqueurs.
- Écarts entre README et code : chaque affirmation d'un README contredite par les fichiers (commande absente des scripts, fichier cité mais absent, procédure annoncée sans configuration), en citant les deux fichiers.
- Tests désactivés : Grep de `\.skip\(|\bxit\(|\bxdescribe\(|\bxtest\(|skip:\s*true|@skip|pytest\.mark\.skip` dans les fichiers de test, avec fichier et ligne.
- Adresses à paramétrer au redéploiement : voir ci-dessous.
- Aucun niveau de risque, de priorité ou de gravité, aucune note, aucune estimation d'effort, aucun jugement (« fragile », « dette », « obsolète »), et rien du livrable `wf-analyse-projet` (ni de `chiffrage` ou `revue-securite`), même s'il est présent.

**Adresses à paramétrer au redéploiement** : cherche les adresses IP et noms de domaine écrits en dur dans le code et la configuration (Grep de `https?://`, `[a-z0-9-]+(\.[a-z0-9-]+)+\.[a-z]{2,}` et `\b\d{1,3}(\.\d{1,3}){3}\b` sur les globs de « Recherches », plus les fichiers de CI lus en entier).
- Exclus : `.env.example`, la documentation (`*.md`, `docs/`), les adresses locales (`localhost`, `127.0.0.1`, `0.0.0.0`, `::1`, `10.0.2.2` de l'émulateur Android), les noms de services internes (services de `docker-compose*.yml` comme `db`, services Kubernetes), les identifiants qui ne sont pas des adresses à joindre (espaces de noms XML, DTD, `$schema`, actions de CI `owner/repo@version`, noms de paquets), les fichiers de verrouillage et les adresses e-mail de données de test ou de démonstration.
- Pour chaque fichier : les numéros de ligne, le rôle de l'adresse établi par le fichier (registre d'images, serveur, webhook de déploiement, API) et son paramètre, puis exactement « à paramétrer au redéploiement ». Ne recopie jamais l'adresse.
- Partout dans le dossier, y compris dans les commandes de « Environnements et déploiement », l'adresse est remplacée par ce paramètre (`<registre>`, `<serveur>`…).

**Checklist de passation** : tableau `| Action | Source | Statut |`, dans cet ordre :
1. une ligne par service tiers de « Services tiers et accès » : « Transférer l'accès au service <service> », source : son fichier ;
2. une ligne par secret du tableau des secrets : « Transmettre le secret `<NOM>` », source : le fichier qui le référence ;
3. en dépôt git seulement, une ligne « Transférer les droits sur le dépôt de code », source : « dépôt git » ; hors git, cette ligne n'est pas créée ;
4. une ligne par branche de « Travaux en cours » : « Fusionner, abandonner ou transmettre la branche `<branche>` », source : « git ».

Chaque ligne porte le statut « à faire » à sa création ; une ligne déjà présente garde le statut saisi (étape 3).

**Points non déterminés** : liste à puces (jamais numérotée) de tout ce qui n'a pas pu être établi : procédure de déploiement non trouvée, branche principale non déterminée, champs qui restent à compléter faute de source, lignes retirées à la relance, contradictions entre fichiers, et ce que la stack non couverte empêche d'analyser. S'il n'y a rien : « - Aucun. »

## Stack non couverte

Projet hors JavaScript/TypeScript et Flutter : en-tête « stack <nom> non couverte en v1 ». Le dossier est produit en entier : déploiement, secrets, travaux en cours, marqueurs, adresses et checklist ne dépendent pas de la stack. Seule différence : « Services tiers et accès » se limite aux indices hors dépendances (fichiers de configuration, CI, `.env.example`) ; ne lis pas le manifeste de dépendances de cette stack (`requirements.txt`, `pyproject.toml`, `composer.json`, `go.mod`, `Gemfile`…) pour y chercher des services, et ne liste pas un service qui n'est établi que par une dépendance ou un import. « Points non déterminés » signale que les dépendances n'ont pas été analysées (stack <nom> non couverte en v1).

## Fin

Écris le dossier avec Write dans `docs/wf/passation.md`, puis termine par un message court : chemin du livrable, création ou mise à jour, nombre de lignes de la checklist par statut et nombre de points non déterminés.
