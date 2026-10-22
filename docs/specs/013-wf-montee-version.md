# Spec 013 : wf-montee-version, plan de montée de version

Statut : validée
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

## Amendement 1 (proposé)

Précisions issues de l'implémentation, à valider. Chacune complète le CA indiqué.

- CA1 : l'en-tête indique « hors git » quand le répertoire n'est pas dans un dépôt ou que le dépôt n'a aucun commit ; la mention « modifications non commitées » ignore le livrable lui-même.
- CA3 : un nom de paquet npm est conforme s'il respecte la forme `(@portée/)nom` du registre, majuscules des anciens noms comprises ; un nom pub est conforme s'il ne contient que des minuscules, des chiffres et `_`.
- CA3 : une dépendance dont le nom n'est pas conforme figure dans l'inventaire, citée telle qu'elle figure dans le manifeste, avec la mention « non vérifié (nom invalide) » et n'est jamais envoyée au registre.
- CA3 : une dépendance du SDK Flutter (`sdk: flutter`) est citée avec son usage, sans dernière version publiée ni écart.
- CA3 : l'écart compare la version installée (à défaut, la plus basse version admise par la contrainte déclarée) et la dernière version publiée : « majeur » si le premier nombre diffère, « mineur » si c'est le deuxième, « correctif » si c'est le troisième ; sans lockfile, il est donc établi à partir de la contrainte déclarée, et n'est « non déterminé » que si la dernière version publiée l'est ou si la contrainte n'a pas de borne basse exploitable.
- CA4 : quand plusieurs fichiers déclarent la version de Node.js et qu'ils divergent, l'inventaire le signale.
- CA5 : la dernière version stable de Flutter, et la version de Dart qu'elle livre, sont tirées de la liste des versions publiées par Flutter.
- CA6 : la dernière version LTS de Node.js est le cycle le plus récent dont la date d'entrée en LTS est passée ; la date de fin de support est celle du cycle de la version déclarée ; un calendrier non publié ou injoignable donne « non déterminé », repris dans « Points non déterminés ».
- CA7 : un paquet inconnu du registre (réponse « introuvable ») est signalé comme tel et n'est pas compté comme registre injoignable ; un registre injoignable est signalé avec le code d'erreur réseau ou le code HTTP reçu.
- CA8 : l'argument prend l'une des formes `<paquet> [version]`, `node [version]` ou `flutter [version]` ; la version est complète (x.y.z) ou partielle (x ou x.y).
- CA8 : une version partielle désigne la plus récente version stable publiée qui commence par elle ; un argument sans version vise la dernière version stable publiée.
- CA8 : avec un argument, « Inventaire des versions » reste complet ; seules les sections à partir de « Cibles retenues » se limitent à la cible.
- CA8 : une dépendance n'est entraînée par la cible que si les métadonnées du registre de la version visée l'exigent ; aucune cible, étape ni commande « recommandée » ou « d'alignement » n'est ajoutée.
- CA9 : les vérifications de l'argument (présence dans les manifestes, existence de la version) ont lieu avant l'inventaire ; en cas d'échec, aucun livrable n'est écrit.
- CA9 : un argument mal formé (nom ou version non conformes) est signalé (« Argument non reconnu ») et aucun livrable n'est écrit.
- CA9 : pour un paquet absent du projet, le message cite la dernière version publiée, ou « non déterminée » si le registre est injoignable, et indique si le paquet n'existe pas non plus sur le registre.
- CA9 : avec un argument et un registre injoignable, le livrable est produit, la cible est marquée « non vérifiée sur le registre » et « Points non déterminés » le signale.
- CA10 : en monorepo, le lot mineur et correctif est formé application par application.
- CA10 : chaque dépendance en écart majeur forme sa propre cible ; elle n'est regroupée avec une autre dépendance en écart majeur que si les métadonnées du registre de sa version visée exigent cette dernière.
- CA10 et CA11 : « Cibles retenues » suit l'ordre : montées qui corrigent une entrée `Sn`, lot mineur et correctif, cibles en écart majeur, environnement d'exécution ou SDK ; une cible exigée par une autre garde sa place dans cette liste, c'est le plan qui la fait passer avant.
- CA10 : aucune cible n'est proposée pour une dépendance d'écart non déterminé, ni pour l'environnement d'exécution ou le SDK dont la dernière version n'a pas pu être établie ; « Points non déterminés » le signale.
- CA11 : une montée correspond à une entrée `Sn` si elle porte sur le même paquet, dans la même application, et que sa version visée est supérieure ou égale à la première version corrigée ; une entrée « aucune correction publiée » n'est atteinte par aucune montée.
- CA11 : si la section « Dépendances vulnérables » indique « non déterminé (base d'avis injoignable) », aucune entrée n'est reprise et « Points non déterminés » signale que les dépendances vulnérables n'ont pas pu être établies ; l'outil ne les recherche pas lui-même.
- CA12 : une rupture est recherchée pour toute cible qui change de version majeure, ou de version mineure pour une version 0.x, et pour l'environnement d'exécution ou le SDK.
- CA12 : une rupture est un changement précis entre la version installée et la version visée (API, option, comportement ou exigence d'environnement) ; un changement précis connu est listé même sans source consultée, marqué « non vérifiée » ; une exigence tirée des métadonnées du registre (dépendance pair, environnement requis) n'est pas une rupture et relève des exigences de CA14 ; un simple changement de version majeure sans changement précis connu n'est pas listé comme rupture, et « Points non déterminés » indique que les ruptures de cette cible n'ont pas été déterminées.
- CA12 : une URL n'est citée comme source que si sa consultation a réussi pendant l'exécution ; sinon la rupture est « non vérifiée », sans URL présentée comme source.
- CA13 : la recherche des usages porte sur tout le code des applications concernées, hors dépendances installées, dossiers de build et fichiers générés ; chaque usage est cité sous la forme `<chemin>:<ligne>`, le nombre total est égal au nombre d'emplacements cités, et la simple importation du paquet n'est pas un impact.
- CA14 : quand la version visée exige une version du SDK Dart, la version de Flutter qui la livre est tirée de la liste des versions publiées par Flutter.
- CA15 : les étapes sont ordonnées ainsi : montées qui corrigent une entrée `Sn`, prérequis exigés par une autre cible (ou dans la même étape), lot mineur et correctif, cibles en écart majeur, puis environnement d'exécution ou SDK.
- CA15 : une étape d'environnement d'exécution ou de SDK indique les fichiers de version à modifier au lieu d'une commande du gestionnaire ; en espace de travail pnpm, la commande cible l'application (`--filter`).
- CA15 et CA19 : sans lockfile pour une application JS/TS, le gestionnaire est « non déterminé » et l'étape indique « commande non déterminée (aucun lockfile) » au lieu d'inventer une commande.
- CA16 : les commandes de vérification utilisent le gestionnaire détecté ; une application qui ne définit qu'une partie des scripts (test, lint, build) ne reçoit que ceux-là.
- CA18 : sans étape, « Plan de montée » contient seulement la phrase « Le plan ne contient aucune étape. ».
- CA20 : les seules commandes lancées sont la date, le commit, l'état du dépôt git et les interrogations en lecture des registres et calendriers ; aucune autre commande, même en lecture (y compris les commandes de consultation des gestionnaires de paquets).
- CA20 : les noms de paquets et les versions, qu'ils viennent de l'argument, d'un manifeste ou d'un lockfile, ne sont jamais interprétés par le shell : ils sont transmis aux commandes par l'entrée standard, puis validés avant tout appel réseau ; un nom sur plusieurs lignes ou identique au marqueur de fin de cette entrée est signalé comme non vérifié sans être transmis.
- CA21 : l'effort est « faible » si aucune rupture n'a d'impact identifié, « moyen » si les ruptures touchent au plus 10 fichiers, « élevé » au-delà ou si l'environnement d'exécution ou le SDK change de version majeure.
- CA22 : les manifestes des stacks non couvertes recherchés sont au moins `composer.json`, `pyproject.toml`, `requirements.txt`, `Gemfile`, `go.mod`, `Cargo.toml`, `pom.xml` et `build.gradle`.
- CA23 : le livrable mis à jour ne cite aucune valeur périmée de l'ancien (date, commit, version qui n'est plus installée ni la dernière publiée), même pour signaler le changement ; la date et le commit de l'en-tête sont relevés à l'exécution.
- CA24 : sans argument, l'en-tête ne comporte aucune mention d'argument.
- CA25 : les fichiers de secrets ou d'identifiants (configuration de registre, propriétés de signature, clés, certificats) ne sont pas lus non plus ; une recherche dans le contenu ne porte que sur des fichiers de code ou sur un manifeste ou lockfile nommé, jamais sur un dossier entier.
- CA26 : un répertoire vide et un répertoire sans manifeste donnent deux messages distincts ; dans les deux cas, aucun registre n'est interrogé.
- CA27 : un `package.json` racine qui ne déclare que des espaces de travail n'est pas une application.
- CA28 : quand les impacts sont partiels, « Ruptures et impacts » l'indique en tête de section.
