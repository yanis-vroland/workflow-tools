# Spec 013 : wf-montee-version, plan de montée de version

Statut : brouillon
Date : 2026-10-09

## Besoin

En tant que freelance qui maintient un projet dont les dépendances, le framework ou le SDK prennent du retard, je veux un plan de montée de version ordonné, avec les ruptures à traiter et les fichiers impactés, afin de mener la montée sans casse et de pouvoir l'estimer ou la proposer au client.

`wf-analyse-projet` signale déjà les dépendances en retard ; cet outil va plus loin : il identifie les ruptures entre la version installée et la version visée, localise leurs impacts dans le code et ordonne les étapes. Le plan reste dans le livrable : l'outil ne modifie ni n'exécute rien. Le livrable s'adresse à moi ou à l'équipe de développement. Il suit l'ADR-001 et son amendement 1 (livrable, honnêteté, lecture seule, accès réseau étendu, dépendances entre outils, stacks couvertes).

## Critères d'acceptation

- CA1 : Étant donné un projet cible, quand je lance `/wf-montee-version` à sa racine, alors le fichier `docs/wf/montee-version.md` est créé et aucun autre fichier du projet n'est modifié, en particulier ni manifeste ni lockfile.
- CA2 : Étant donné le livrable produit, alors il contient dans cet ordre les sections : Synthèse, Inventaire des versions, Cibles retenues, Ruptures et impacts, Plan de montée, Vérifications, Points non déterminés.
- CA3 : Étant donné le livrable, alors « Inventaire des versions » contient, pour chaque dépendance directe déclarée dans `package.json` ou `pubspec.yaml`, une ligne avec : nom, contrainte déclarée, version installée (tirée de `package-lock.json`, `pnpm-lock.yaml`, `yarn.lock` ou `pubspec.lock`), dernière version publiée (obtenue sur le registre npm ou pub.dev), écart (majeur, mineur, correctif ou à jour), et usage (`dependencies` ou `devDependencies` pour npm, `dependencies` ou `dev_dependencies` pour pub).
- CA4 : Étant donné un projet JS/TS qui déclare une version de Node.js (`engines` de `package.json`, `.nvmrc`, `.node-version`, image de base d'un `Dockerfile`), alors « Inventaire des versions » la cite avec le fichier qui la déclare et la dernière version LTS publiée.
- CA5 : Étant donné un projet Flutter, alors « Inventaire des versions » cite la contrainte du SDK Dart (`environment.sdk` de `pubspec.yaml`), la contrainte Flutter (`environment.flutter`) si elle existe, la version de Flutter épinglée (`.fvmrc` ou `.fvm/fvm_config.json`) si elle existe, chacune avec son fichier, et la dernière version stable publiée de Flutter.
- CA6 : Étant donné un environnement d'exécution ou un SDK inventorié (CA4, CA5) dont endoflife.date publie le calendrier, alors l'inventaire indique la date de fin de support de la version déclarée ; une version dont la fin de support est passée est signalée dans « Synthèse ». Sans calendrier publié, la date est « non déterminé ».
- CA7 : Étant donné un registre de paquets injoignable, alors l'outil se replie sur les versions du lockfile, indique « non déterminé » pour les dernières versions publiées, le signale dans « Points non déterminés » et produit tout de même le livrable.
- CA8 : Étant donné un argument désignant une cible (ex. `/wf-montee-version react 19` ou `/wf-montee-version flutter 3.27`), alors « Cibles retenues » ne contient que cette cible, et les sections suivantes ne portent que sur elle et sur les dépendances qu'elle entraîne (CA14).
- CA9 : Étant donné un argument désignant un paquet absent du projet, ou une version inexistante dans le registre, quand je lance l'outil, alors il l'indique, cite la dernière version publiée si le paquet existe, et n'écrit aucun livrable.
- CA10 : Étant donné aucun argument, alors « Cibles retenues » contient toutes les dépendances en retard : un lot unique pour les écarts mineurs et correctifs, puis une cible par écart majeur, et une cible pour l'environnement d'exécution ou le SDK s'il n'est pas à la dernière version stable ou LTS.
- CA11 : Étant donné un livrable `docs/wf/revue-securite.md` présent, alors chaque montée qui atteint la première version corrigée d'une entrée de sa section « Dépendances vulnérables » cite l'identifiant `Sn` correspondant et est placée en tête de « Cibles retenues » et du plan ; ce livrable n'est jamais modifié. Absent, l'outil n'en tient pas compte et ne recherche pas lui-même les vulnérabilités.
- CA12 : Étant donné une rupture citée dans « Ruptures et impacts », alors elle a un identifiant (R1, R2…) et sa source : URL de la note de version ou du guide de migration officiel consulté. Une rupture dont aucune source n'a pu être consultée est marquée « non vérifiée ».
- CA13 : Étant donné une rupture qui touche une API utilisée par le projet (ex. fonction, classe ou widget renommé ou supprimé), alors « Ruptures et impacts » cite chaque fichier et ligne où cette API est utilisée, et leur nombre total ; une rupture qui ne touche aucune API utilisée est indiquée « sans impact identifié ».
- CA14 : Étant donné une cible dont la version visée exige une version d'une autre dépendance ou de l'environnement (dépendance pair ou `engines` pour npm, contrainte `environment.sdk` ou `environment.flutter` pour pub, selon les métadonnées du registre), alors cette autre dépendance est ajoutée au plan, dans une étape qui précède ou accompagne celle de la cible.
- CA15 : Étant donné le livrable, alors chaque étape de « Plan de montée » est numérotée et comporte : les paquets concernés avec version de départ et version visée, les commandes du gestionnaire détecté d'après le lockfile (`npm install <paquet>@<version>`, `pnpm add`, `yarn add`, `flutter pub add` ou `flutter pub upgrade`), les identifiants des ruptures à traiter, et la vérification à faire avant de passer à l'étape suivante.
- CA16 : Étant donné un projet qui définit des scripts de test, de lint ou de build (`package.json`), ou un projet Flutter (`flutter analyze`, `flutter test`), alors « Vérifications » donne ces commandes, tirées des fichiers du projet ou de la stack détectée.
- CA17 : Étant donné un projet JS/TS sans script de test ni de build identifiable, alors « Vérifications » l'indique, « Points non déterminés » le reprend, et aucune commande n'est inventée.
- CA18 : Étant donné un projet dont toutes les dépendances sont à jour (ou, avec un argument, une cible déjà à la version visée), alors « Synthèse » l'indique et « Plan de montée » ne contient aucune étape.
- CA19 : Étant donné un projet sans lockfile, alors les versions installées sont indiquées « non déterminé », l'inventaire se fonde sur les contraintes déclarées, et « Points non déterminés » le signale.
- CA20 : Étant donné un projet cible, quand l'outil s'exécute, alors il n'installe ni ne met à jour aucune dépendance, ne lance pas le projet, n'exécute pas ses tests et ne crée ni branche ni commit.
- CA21 : Étant donné le livrable, alors « Synthèse » donne le nombre de dépendances par écart (majeur, mineur, correctif, à jour), le nombre d'étapes du plan, et un effort qualitatif global (faible, moyen, élevé) justifié par le nombre de ruptures et de fichiers impactés, sans chiffrage en jours.
- CA22 : Étant donné un projet d'une stack non couverte en v1 (ex. `composer.json`, `pyproject.toml`), alors « Inventaire des versions » la signale « non couverte » et aucune cible n'est proposée pour elle ; dans un projet mixte, les parties JS/TS et Flutter sont traitées normalement.
- CA23 : Étant donné un livrable `docs/wf/montee-version.md` déjà présent, quand je relance l'outil, alors il est mis à jour au lieu d'être dupliqué, et l'inventaire reflète les versions actuelles du lockfile.
- CA24 : Étant donné le livrable, alors son en-tête comporte, en plus des mentions prévues par l'ADR-001, l'argument passé s'il y en a un.
- CA25 : Étant donné un projet contenant un fichier `.env*` autre que `.env.example`, alors l'outil ne lit pas ce fichier et le livrable ne contient aucune de ses valeurs.
- CA26 : Étant donné un répertoire vide ou sans manifeste de dépendances, quand je lance l'outil, alors il l'indique et n'écrit aucun livrable.
- CA27 : Étant donné un monorepo (espaces de travail npm, pnpm ou yarn, ou plusieurs manifestes, ex. FieldOps : application web et application compagnon Flutter), alors « Inventaire des versions » a une sous-section par application, et une même dépendance présente dans plusieurs applications à des versions différentes est signalée.
- CA28 : Étant donné une partie du code que l'outil n'a pas lue lors de la recherche d'impacts (projet volumineux), alors « Points non déterminés » liste les dossiers non lus, et les impacts sont présentés comme partiels.

## Cas limites et erreurs

Couverts par CA7, CA9, CA11 (livrable de sécurité absent), CA17 à CA19, et CA22 à CA28.

## Hors périmètre

- Diagnostic global de l'état du projet (c'est `wf-analyse-projet`).
- Recherche de vulnérabilités dans les dépendances (c'est `wf-revue-securite`, dont le livrable est lu s'il existe).
- Application de la montée : modification des manifestes, du lockfile ou du code, installation, exécution des tests (lecture seule en v1, amendement 1 de l'ADR-001).
- Chiffrage en jours (c'est `wf-chiffrage`).
- Recette fonctionnelle après la montée (c'est `wf-recette`).
- Montée des SDK natifs Android et iOS (Gradle, CocoaPods, `targetSdk`) d'une application Flutter : couverte par aucun outil en v1, prévue pour cet outil après la v1 (`wf-publication-store` en signale seulement les exigences des stores).
- Préparation de la publication sur les stores (c'est `wf-publication-store`).
- Migration vers un autre framework ou langage.
- Stacks autres que JS/TS et Flutter en v1.

## Questions ouvertes

- Aucune.
