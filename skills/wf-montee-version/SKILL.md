---
name: wf-montee-version
description: Génère ou met à jour docs/wf/montee-version.md, un plan de montée de version ordonné (inventaire des versions, cibles, ruptures avec leurs fichiers impactés, étapes avec commandes et vérifications) pour les dépendances, Node.js ou Flutter d'un projet JS/TS ou Flutter. À utiliser avec /wf-montee-version [paquet|node|flutter [version]], ou quand on demande de planifier une mise à jour de dépendances, de framework ou de SDK sur le projet courant.
---

# wf-montee-version

Tu rédiges, en français, un plan de montée de version du projet ouvert dans le répertoire courant (le projet cible), pour le freelance ou l'équipe de développement. Le plan identifie les ruptures entre la version installée et la version visée, localise leurs impacts dans le code et ordonne les étapes. Le plan reste dans le livrable : tu ne modifies ni n'exécutes rien. Ce n'est ni un diagnostic global (`wf-analyse-projet`), ni une recherche de vulnérabilités (`wf-revue-securite`), ni un chiffrage en jours (`wf-chiffrage`).

## Règles absolues

- **Écriture** : un seul fichier, `docs/wf/montee-version.md`, écrit avec l'outil Write (qui crée `docs/wf/` au besoin ; pas de `mkdir`). Aucun autre fichier du projet n'est créé, modifié, déplacé ou supprimé : ni manifeste, ni lockfile, ni code, ni livrable d'un autre outil (`docs/wf/revue-securite.md` est seulement lu). Pas d'outil Edit sur un autre fichier, pas de redirection `>` ni de `curl -o`.
- **Aucune installation ni exécution** : tu n'installes ni ne mets à jour aucune dépendance, tu ne lances pas le projet, n'exécutes pas ses tests ni ses scripts, et tu ne crées ni branche ni commit. Les commandes `npm install`, `pnpm add`, `yarn add`, `flutter pub add`, `flutter pub upgrade` et les commandes de vérification sont **écrites dans le livrable, jamais lancées**. Bash ne sert qu'à : `git rev-parse --short HEAD`, `git status --porcelain`, `date +%F` (chacune seule, recopiée telle quelle) et aux commandes `curl` des blocs ci-dessous, où tu ne remplaces que les valeurs entre apostrophes `'<…>'`. N'y écris qu'un nom de paquet ou une version déjà vérifiés contre leur motif (étape 1 et étape 5), qui n'admettent ni apostrophe, ni guillemet, ni espace, ni `$` ; une valeur non conforme (argument, nom lu dans un manifeste) n'entre jamais dans une commande, ni entre guillemets doubles, ni hors des apostrophes. Aucune autre commande, même en lecture (`ls`, `cat`, `find`, `npm view`, `npm outdated`) : pour lire, utilise Read, Glob et Grep.
- **Réseau** : seulement des noms et versions de paquets, jamais de code ni de contenu du projet. Registres et calendriers par `curl` (blocs ci-dessous) ; notes de version, changelogs et guides de migration officiels par WebFetch. Aucune base d'avis de sécurité (OSV.dev, `npm audit`, GitHub Advisories) : tu ne recherches pas toi-même les vulnérabilités.
- **Secrets** : ne lis jamais, ni avec Read, ni avec Grep, ni avec Bash, un fichier d'environnement (`.env`, `.env.local`, `.env.production`…, sauf `.env.example`) ni un fichier de secrets ou d'identifiants (`.envrc`, `.npmrc`, `android/key.properties`, clés et certificats). Avec Grep, passe toujours soit le paramètre `glob` limité à des extensions de code (ex. `*.{ts,tsx,js,jsx,mjs,cjs,vue,dart}`), soit un `path` qui désigne un seul fichier nommé (manifeste ou lockfile), jamais un dossier sans `glob` : en mode contenu, Grep afficherait les lignes d'un fichier d'environnement. Le livrable ne contient aucune valeur de variable d'environnement.
- **Données personnelles** : aucune adresse e-mail (de contributeur ou autre) dans le livrable.
- **Honnêteté** : chaque version, contrainte ou usage s'appuie sur un fichier lu, dont le chemin (relatif à la racine) est cité ; chaque dernière version publiée, date de fin de support ou exigence d'un paquet s'appuie sur la sortie d'une commande `curl` de cette session ; chaque rupture sur une source consultée ou porte la mention « non vérifiée ». Ce qui n'a pas pu être établi est écrit « non déterminé », jamais deviné ni complété de mémoire.

## Étape 1 : argument

Lis l'argument passé après `/wf-montee-version` (par exemple `/wf-montee-version vue 3` ou `/wf-montee-version flutter 3.27`). Formes reconnues :

- aucun argument : toutes les dépendances en retard (étape 6) ;
- `<paquet> [version]` : un paquet npm (nom conforme à `^(@[a-z0-9._-]+/)?[a-z0-9._-]+$`) ou pub (`^[a-z0-9_]+$`) ;
- `node [version]` ou `flutter [version]` : l'environnement d'exécution ou le SDK.

La version est complète (`3.4.0`) ou partielle (`3`, `3.27`) ; elle doit être conforme à `^[0-9]+(\.[0-9]+){0,2}$`. Une version partielle désigne la plus récente version stable publiée qui commence par elle ; sans version, la cible est la dernière version stable publiée. Argument mal formé : réponds « Argument non reconnu : <argument> : aucun livrable n'a été écrit. » et arrête-toi.

Avec un argument, fais d'abord, juste après l'étape 2, les vérifications « Avec argument » de l'étape 6 (présence du paquet dans les manifestes, existence de la version) : si l'une échoue, arrête-toi avant l'inventaire, sans écrire de livrable. L'inventaire (étape 5) reste complet ; seules les sections à partir de « Cibles retenues » se limitent à la cible.

## Étape 2 : manifestes

Avec Glob, cherche les manifestes `package.json` et `pubspec.yaml`, et ceux des stacks non couvertes (`composer.json`, `pyproject.toml`, `requirements.txt`, `Gemfile`, `go.mod`, `Cargo.toml`, `pom.xml`, `build.gradle`), hors `node_modules/`, `.dart_tool/`, `build/`, `dist/` et sous-dossiers `android/` et `ios/` d'une application Flutter.

- Répertoire vide (aucun fichier hors `.git`) : n'écris rien et termine par « Le répertoire est vide : aucun livrable n'a été écrit. »
- Aucun manifeste : n'écris rien, ne crée aucun dossier, n'interroge aucun registre, et termine par « Aucun manifeste de dépendances trouvé : aucun livrable n'a été écrit. »

Applications : chaque dossier qui porte un `package.json` (avec dépendances) ou un `pubspec.yaml` est une application, nommée d'après son dossier ou son manifeste ; un monorepo en contient plusieurs (espaces de travail npm `workspaces`, `pnpm-workspace.yaml`, yarn, ou plusieurs manifestes comme une application web et une application Flutter). Un `package.json` racine qui ne déclare que des espaces de travail n'est pas une application. Les stacks couvertes en v1 sont JS/TS (npm, pnpm, yarn) et Flutter (pub). Toute autre stack est signalée « non couverte » dans l'inventaire (manifeste cité), sans version, sans cible ni rupture ; dans un projet mixte, les parties JS/TS et Flutter sont traitées normalement.

## Étape 3 : en-tête

- Date : `date +%F`.
- Commit : `git rev-parse --short HEAD`. Si la commande échoue (pas de dépôt, ou dépôt sans commit), écris « hors git » et ne lance pas `git status`.
- `git status --porcelain` : si la sortie contient au moins une ligne qui ne concerne pas `docs/wf/montee-version.md`, ajoute « modifications non commitées ».
- Argument : s'il y en a un, ajoute « Argument : `<argument tel que passé>` ». Sans argument, n'ajoute pas cette mention.

## Étape 4 : livrable existant et livrable de sécurité

- Si `docs/wf/montee-version.md` existe, lis-le d'abord. Tu le réécriras en entier avec Write : un seul plan dans le fichier (jamais l'ancien suivi du nouveau), aucune copie datée ou numérotée. L'inventaire reflète les versions actuelles du lockfile ; conserve seulement ce qui reste vrai, et mets à jour la date, le commit et l'argument.
- Si `docs/wf/revue-securite.md` existe, lis sa section « Dépendances vulnérables » : chaque entrée a un identifiant `Sn`, un nom, un écosystème, une version installée et une première version corrigée (ou « aucune correction publiée »). Ne reprends que ces entrées (pas les constats dans le code ni les secrets), et ne modifie jamais ce fichier. S'il est absent, n'en tiens pas compte.

## Étape 5 : inventaire des versions

Pour chaque application, lis le manifeste et le lockfile de son dossier ou de la racine du monorepo (Read, ou, pour un lockfile volumineux, Grep sur le nom du paquet avec `path` désignant ce seul fichier).

- **Dépendances directes** : toutes celles de `dependencies` et `devDependencies` (`package.json`), ou de `dependencies` et `dev_dependencies` (`pubspec.yaml`) ; l'usage est le nom de cette section. Les dépendances du SDK (`sdk: flutter`) sont citées avec l'usage, sans version publiée.
- **Version installée** : tirée du lockfile : `package-lock.json` (entrée `node_modules/<paquet>`, ou `<dossier>/node_modules/<paquet>` en espace de travail), `pnpm-lock.yaml` (`importers` → dossier → `version`), `yarn.lock`, `pubspec.lock`. Le lockfile donne aussi le gestionnaire détecté : npm, pnpm, yarn ou pub. Sans lockfile (aucun lockfile pour une application JS/TS ou Flutter), la version installée est « non déterminé », l'inventaire se fonde sur la contrainte déclarée, le gestionnaire JS/TS est « non déterminé », et « Points non déterminés » le signale. Ne déduis jamais une version installée d'une contrainte.
- **Dernière version publiée** : interroge les registres, une commande par écosystème, avec tous les noms de paquets vérifiés (un nom non conforme n'est jamais écrit dans une commande : signale-le comme non vérifié). Écris chaque nom entre apostrophes simples.

```bash
for p in '<paquet>' '<@scope/paquet>'; do
  [[ $p =~ ^(@[a-z0-9._-]+/)?[a-z0-9._-]+$ ]] || { echo "npm $p nom invalide, ignoré"; continue; }
  out=$(curl -s --max-time 10 -w '\n%{http_code}' "https://registry.npmjs.org/${p/\//%2F}/latest"); rc=$?; code=${out##*$'\n'}
  case "$rc:$code" in
    0:200) echo "npm $p $(grep -oE '"(version|engines|peerDependencies)":("[^"]*"|\{[^}]*\})' <<<"$out" | tr '\n' ' ')" ;;
    0:404) echo "npm $p introuvable (404)" ;;
    *) echo "npm $p injoignable (curl $rc)" ;;
  esac
done
```

```bash
for p in '<paquet>'; do
  [[ $p =~ ^[a-z0-9_]+$ ]] || { echo "pub $p nom invalide, ignoré"; continue; }
  out=$(curl -s --max-time 10 -w '\n%{http_code}' "https://pub.dev/api/packages/$p"); rc=$?; code=${out##*$'\n'}
  case "$rc:$code" in
    0:200) echo "pub $p $(grep -oE '"latest":\{"version":"[^"]*"' <<<"$out" | head -1) $(grep -oE '"latest":\{.*' <<<"$out" | grep -oE '"environment":\{[^}]*\}' | head -1)" ;;
    0:404) echo "pub $p introuvable (404)" ;;
    *) echo "pub $p injoignable (curl $rc)" ;;
  esac
done
```

- **Écart** entre la version installée (à défaut, la plus basse version admise par la contrainte) et la dernière version publiée : « majeur » si le premier nombre diffère, « mineur » si le deuxième diffère, « correctif » si le troisième diffère, « à jour » sinon. Écart « non déterminé » si l'une des deux versions l'est.
- **Monorepo** : une sous-section `###` par application. Une même dépendance installée dans plusieurs applications à des versions différentes est signalée sous l'inventaire : « Versions différentes entre applications : `<paquet>` <version> (`<application>`) et <version> (`<application>`) ».
- **Registre injoignable** (`injoignable` dans la sortie) : garde les versions du lockfile, écris « non déterminé » pour la dernière version publiée et l'écart, signale dans « Points non déterminés » le registre injoignable et le repli sur le lockfile, et produis tout de même le livrable. Ne complète jamais une version de mémoire. Un paquet introuvable (404) n'est pas un registre injoignable : le registre ne le connaît pas (paquet privé, renommé ou retiré), dis-le.

### Environnement d'exécution et SDK

- **Node.js** (application JS/TS) : cite chaque déclaration de version avec son fichier : `engines` de `package.json`, `.nvmrc`, `.node-version`, image de base (`FROM node:<version>`) d'un `Dockerfile`. S'ils divergent, dis-le.
- **Flutter** (application Flutter) : cite la contrainte du SDK Dart (`environment.sdk` de `pubspec.yaml`), la contrainte Flutter (`environment.flutter`) si elle existe, et la version épinglée (`.fvmrc` ou `.fvm/fvm_config.json`) si elle existe, chacune avec son fichier.
- **Dernière version LTS de Node.js, fin de support** (endoflife.date) et **dernière version stable de Flutter** (versions publiées par Flutter, avec la version de Dart livrée) :

```bash
for product in 'nodejs' 'flutter'; do
  out=$(curl -s --max-time 10 -w '\n%{http_code}' "https://endoflife.date/api/$product.json"); rc=$?; code=${out##*$'\n'}
  case "$rc:$code" in
    0:200) echo "endoflife.date $product :"; grep -oE '\{"cycle":"[^"]*"[^}]*\}' <<<"$out" ;;
    0:404) echo "endoflife.date $product : aucun calendrier publié (404)" ;;
    *) echo "endoflife.date $product injoignable (curl $rc)" ;;
  esac
done
out=$(curl -s --max-time 20 -w '\n%{http_code}' 'https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json'); rc=$?; code=${out##*$'\n'}
case "$rc:$code" in
  0:200) echo "Flutter stable :"; grep -A2 '"channel": "stable"' <<<"$out" | grep -oE '"(version|dart_sdk_version)": "[^"]*"' | paste -d' ' - - ;;
  *) echo "versions de Flutter injoignables (curl $rc)" ;;
esac
```

N'interroge que les produits présents dans le projet. La dernière LTS de Node.js est le cycle le plus récent dont le champ `lts` est une date passée (comparée à `date +%F`) ; la dernière stable de Flutter est la première version listée. La fin de support de la version déclarée est le champ `eol` de son cycle ; si elle est passée, « Synthèse » le signale. Sans calendrier publié (404) ou source injoignable, la date est « non déterminé », de même que la dernière version, et « Points non déterminés » le reprend.

## Étape 6 : cibles retenues

- **Sans argument** : toutes les dépendances en retard. Les dépendances en écart mineur ou correctif forment un **lot unique** (une seule cible, application par application en monorepo) ; puis une cible par dépendance en écart majeur ; puis une cible pour Node.js ou Flutter s'il n'est pas à la dernière version LTS ou stable (dernière version non déterminée : pas de cible, le dire et le reprendre dans « Points non déterminés »). Aucune cible pour une dépendance à jour, d'écart non déterminé, ou d'une stack non couverte.
- **Avec argument** : « Cibles retenues » ne contient que cette cible, et les sections suivantes ne portent que sur elle et sur les dépendances qu'elle entraîne (exigences ci-dessous). Pour un paquet, vérifie sa présence dans les manifestes, puis ses versions publiées :

```bash
for pv in '<paquet>@<version>'; do
  p=${pv%@*}; v=${pv##*@}
  [[ $p =~ ^(@[a-z0-9._-]+/)?[a-z0-9._-]+$ && $v =~ ^[0-9]+(\.[0-9]+){0,2}$ ]] || { echo "npm $pv invalide, ignoré"; continue; }
  out=$(curl -s --max-time 20 -H 'Accept: application/vnd.npm.install-v1+json' -w '\n%{http_code}' "https://registry.npmjs.org/${p/\//%2F}"); rc=$?; code=${out##*$'\n'}
  case "$rc:$code" in
    0:200) echo "npm $p $(grep -oE '"latest":"[^"]*"' <<<"$out" | head -1) ; versions $v : $(grep -oE '"[0-9]+\.[0-9]+\.[0-9]+":\{"name"' <<<"$out" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | grep -E "^${v//./\\.}(\\.|$)" | sort -t. -k1,1n -k2,2n -k3,3n | tail -3 | tr '\n' ' ')" ;;
    0:404) echo "npm $p introuvable (404)" ;;
    *) echo "npm $p injoignable (curl $rc)" ;;
  esac
done
```

  Pour un paquet pub, la commande pub de l'étape 5 donne la dernière version, et `https://pub.dev/api/packages/<paquet>/versions/<x.y.z>` (même forme de commande, `0:404` = version inexistante) vérifie une version précise. Pour `node` ou `flutter`, cherche la version dans les sorties de l'étape 5.
  - Paquet absent des manifestes du projet : n'écris aucun livrable et termine par « Le paquet `<paquet>` n'est pas une dépendance du projet (dernière version publiée : <x.y.z>, registre <npm|pub.dev>) : aucun livrable n'a été écrit. » (dernière version « non déterminée » si le registre est injoignable ; s'il répond 404, dis que le paquet n'existe pas non plus sur le registre).
  - Version inexistante (aucune version publiée ne correspond) : n'écris aucun livrable et termine par « La version `<version>` de `<paquet>` n'existe pas sur le registre <npm|pub.dev> (dernière version publiée : <x.y.z>) : aucun livrable n'a été écrit. »
  - Registre injoignable : produis le livrable avec la version demandée, « non vérifiée sur le registre », et signale-le dans « Points non déterminés ».
  - Cible déjà à la version visée (ou au-delà) : « Synthèse » l'indique, aucune rupture, et « Plan de montée » ne contient aucune étape.
- **Livrable de sécurité** : chaque montée dont la version visée est supérieure ou égale à la première version corrigée d'une entrée `Sn` de « Dépendances vulnérables » (même paquet, même application) cite cet identifiant et est placée en tête de « Cibles retenues » et du plan.
- **Exigences d'une cible** (selon les métadonnées du registre, jamais de mémoire) : pour npm, `peerDependencies` et `engines` de la version visée (commande de l'étape 5 avec `/<version>` à la place de `/latest` pour une version qui n'est pas la dernière) ; pour pub, `environment.sdk` et `environment.flutter` de la version visée. Si la version visée exige une version d'une autre dépendance du projet, de Node.js, du SDK Dart ou de Flutter que le projet ne satisfait pas, cette autre dépendance est ajoutée au plan, dans une étape qui précède ou accompagne celle de la cible, avec la mention de l'exigence et de sa source. Pour le SDK Dart, la version de Flutter qui le livre est tirée de la sortie « Flutter stable ».

## Étape 7 : ruptures et impacts

Pour chaque cible dont la version visée change de version majeure (ou de version mineure pour une version 0.x), et pour Node.js ou Flutter :

- **Source** : consulte avec WebFetch la note de version, le changelog ou le guide de migration officiel : `https://pub.dev/packages/<paquet>/changelog` pour pub, le `CHANGELOG.md` ou les notes de version du dépôt indiqué par le champ `repository` du registre, ou le guide de migration publié par le projet. Cite l'URL exacte consultée avec succès. Une rupture dont aucune source n'a pu être consultée (refus, erreur, réseau coupé) est citée avec la mention « non vérifiée », sans URL présentée comme source.
- **Identifiant** : R1, R2… dans l'ordre du livrable ; le plan y renvoie.
- **Impacts** : pour chaque API renommée ou supprimée (fonction, classe, widget, option), cherche ses usages avec Grep (`output_mode: content`, numéros de ligne, `glob` limité aux extensions de code) dans tout le code des applications concernées, hors `node_modules/`, `.dart_tool/`, `build/`, `dist/` et fichiers générés. Cite chaque fichier et ligne (`<chemin>:<ligne>`) et le nombre total d'occurrences. Une rupture qui ne touche aucune API utilisée est indiquée « sans impact identifié ».
- **Impacts partiels** : si une partie du code n'a pas été couverte par la recherche (dossier exclu parce que trop volumineux, résultat tronqué), liste ces dossiers non lus dans « Points non déterminés » et écris en tête de « Ruptures et impacts » que les impacts sont partiels (« impacts partiels : dossiers non lus listés dans Points non déterminés »).

## Étape 8 : plan et vérifications

- **Plan de montée** : une étape `###` numérotée par cible, dans l'ordre : montées qui corrigent une entrée `Sn`, puis prérequis exigés par une autre cible (ou dans la même étape), puis le lot mineur et correctif, puis les cibles majeures, puis l'environnement. Chaque étape comporte : les paquets concernés avec version de départ et version visée (et l'application en monorepo) ; les commandes du gestionnaire détecté d'après le lockfile : `npm install <paquet>@<version>` (npm), `pnpm add <paquet>@<version>` (pnpm, avec `--filter <application>` en espace de travail), `yarn add <paquet>@<version>` (yarn), `flutter pub add <paquet>:^<version>` ou `flutter pub upgrade` (pub) ; pour Node.js ou Flutter, les fichiers de version à modifier ; sans lockfile JS/TS, « commande non déterminée (aucun lockfile) » ; les identifiants des ruptures à traiter (ou « aucune ») ; la vérification à faire avant l'étape suivante (commandes de « Vérifications »). Sans cible, ou cible déjà atteinte, le plan ne contient aucune étape : écris seulement « Le plan ne contient aucune étape. », sans liste ni commande.
- **Vérifications** : par application, les commandes tirées des fichiers du projet : scripts `test`, `lint`, `build` (et équivalents) de `package.json`, lancés avec le gestionnaire détecté (`npm test`, `npm run lint`, `npm run build`, `pnpm --filter <application> test`, `yarn test`…), avec le fichier source ; pour une application Flutter, `flutter analyze` et `flutter test`. Projet JS/TS sans script de test ni de build : écris « aucun script de test ni de build identifié dans `package.json` », reprends-le dans « Points non déterminés », et n'invente aucune commande (ni `npm test`, ni `npx`, ni outil de test) ; une application qui n'a qu'un script reçoit seulement celui-là.

## Modèle du livrable

Titres de section en `##`, exactement dans cet ordre, sans table des matières. Sous-sections en `###`.

```markdown
# Plan de montée de version de <nom du projet>

Outil : wf-montee-version · Date : AAAA-MM-JJ · Commit : <sha court ou « hors git »>[ · modifications non commitées][ · Argument : `<argument>`]

## Synthèse

- Dépendances : N majeur, N mineur, N correctif, N à jour[, N non déterminé].
- Plan : N étapes (ou « aucune étape » : tout est à jour, ou cible déjà à la version visée).
- Effort global : **faible|moyen|élevé**, justifié par N ruptures (R1…) et N fichiers impactés.
- <Version en fin de support passée, avec son fichier et sa date.>

## Inventaire des versions

### <Application> (`<dossier>`, <gestionnaire> d'après `<lockfile>`)

| Dépendance | Contrainte déclarée | Installée | Dernière publiée | Écart | Usage |
|---|---|---|---|---|---|
| `<paquet>` | `<contrainte>` | <x.y.z> | <x.y.z> | majeur | `dependencies` |

Environnement :
- <Node.js|SDK Dart|Flutter> : <version> (`<fichier>`) ; dernière version <LTS|stable> : <x.y.z> (<source>) ; fin de support de la version déclarée : AAAA-MM-JJ (endoflife.date) ou non déterminé.

### <Partie d'une stack non couverte> (`<manifeste>`) : stack <nom> non couverte en v1

Versions différentes entre applications : `<paquet>` <x.y.z> (`<application>`) et <x.y.z> (`<application>`).

## Cibles retenues

1. `<paquet>` <x.y.z> → <x.y.z>[ (corrige Sn)][ ; entraîné par `<paquet>` : <exigence>, registre <npm|pub.dev>].
2. Lot mineur et correctif : `<paquet>` <x.y.z> → <x.y.z>, …

## Ruptures et impacts

### R1 : <rupture> (`<paquet>` <x> → <y>)

- Source : <URL consultée> | non vérifiée (aucune source consultée)
- Impacts (N occurrences) : `<chemin>:<ligne>`, … | sans impact identifié

## Plan de montée

### Étape 1 : <titre>[ (Sn)]

- Paquets : `<paquet>` <x.y.z> → <x.y.z>[ (`<application>`)]
- Commandes : `<commande du gestionnaire>`
- Ruptures à traiter : R1, R2 | aucune
- Vérification avant l'étape suivante : `<commande>`

## Vérifications

### <Application>

- `<commande>` (`<fichier source>`)

## Points non déterminés

- <Point, avec les fichiers ou sources concernés.>
```

## Remplir chaque section

**Synthèse** : nombres de dépendances par écart (majeur, mineur, correctif, à jour), nombre d'étapes du plan (identique à « Plan de montée »), et un effort qualitatif global, exactement « faible », « moyen » ou « élevé », justifié par le nombre de ruptures et de fichiers impactés : faible si aucune rupture n'a d'impact identifié, moyen si les ruptures touchent quelques fichiers (jusqu'à 10), élevé au-delà ou si l'environnement d'exécution ou le SDK change de version majeure. Aucun chiffrage en jours, semaines ou heures. Signale toute version en fin de support passée, et, si tout est à jour (ou la cible déjà atteinte), dis-le.

**Points non déterminés** : liste à puces de tout ce qui n'a pas pu être établi (registre ou source injoignable et repli sur le lockfile, lockfile absent, dernière version ou fin de support non déterminée, scripts de vérification absents, dossiers non lus, stack non couverte). S'il n'y a rien : « - Aucun. »

## Fin

Écris le livrable avec Write dans `docs/wf/montee-version.md`, puis termine par un message court : chemin du livrable, création ou mise à jour, nombre d'étapes, effort global et nombre de points non déterminés.
