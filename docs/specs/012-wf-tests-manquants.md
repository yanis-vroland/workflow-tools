# Spec 012 : wf-tests-manquants, tests à écrire en priorité

Statut : validée
Date : 2026-10-09

## Besoin

En tant que freelance qui reprend ou fait évoluer un projet peu testé, je veux savoir quels tests manquent et lesquels écrire en premier, avec un point de départ concret pour chacun, afin de sécuriser les modifications sur les zones les plus exposées.

`wf-analyse-projet` signale déjà les fichiers non couverts ; cet outil va plus loin : il descend au niveau des fonctions et des branches, priorise selon des critères mesurables, et propose des squelettes de tests à copier dans le projet. Le livrable s'adresse à moi ou à l'équipe de développement. Il suit l'ADR-001 et son amendement 1 (livrable, honnêteté, lecture seule, stacks couvertes).

## Critères d'acceptation

- CA1 : Étant donné un projet cible, quand je lance `/wf-tests-manquants` à sa racine, alors le fichier `docs/wf/tests-manquants.md` est créé et aucun autre fichier du projet n'est modifié, en particulier aucun fichier de test.
- CA2 : Étant donné le livrable produit, alors il contient dans cet ordre les sections : Synthèse, Outillage de test, Couverture actuelle, Tests manquants, Cas manquants dans le code testé, Squelettes de tests, Points non déterminés.
- CA3 : Étant donné un projet JS/TS doté d'un framework de test (ex. Jest, Vitest, Playwright), alors « Outillage de test » cite le ou les frameworks avec le fichier qui les déclare (`package.json`, fichier de configuration du framework), la commande de lancement tirée des scripts de `package.json`, et le nombre de fichiers de test.
- CA4 : Étant donné un projet Flutter, alors « Outillage de test » cite `flutter_test` (et `integration_test` s'il est déclaré) d'après `pubspec.yaml`, la commande `flutter test`, et le nombre de fichiers `*_test.dart` dans `test/` et `integration_test/`.
- CA5 : Étant donné un rapport de couverture déjà présent dans le projet (`coverage/lcov.info`, produit notamment par `flutter test --coverage`, ou `coverage/coverage-summary.json`), alors « Couverture actuelle » l'exploite, cite son chemin et sa date de modification, et signale s'il est antérieur au dernier commit.
- CA6 : Étant donné aucun rapport de couverture présent, alors « Couverture actuelle » applique l'heuristique de `wf-analyse-projet` (un fichier source est réputé couvert si un fichier de test l'importe ou porte son nom, ex. `invoice.ts` et `invoice.test.ts`, ou `invoice.dart` et `invoice_test.dart`) et précise qu'elle est approximative.
- CA7 : Étant donné un projet cible, quand l'outil s'exécute, alors il ne lance pas les tests, ne mesure pas la couverture et n'installe aucune dépendance.
- CA8 : Étant donné le livrable, alors chaque entrée de « Tests manquants » comporte : un identifiant stable (M1, M2…, préfixe « M » pour ne pas être confondu avec les tickets `Tnn` de `wf-specs-tickets`), le fichier source, les fonctions, classes, composants ou widgets exportés à tester (par leur nom), le type de test proposé (unitaire, composant ou widget, intégration, bout en bout), une priorité (haute, moyenne, faible) et la justification de cette priorité.
- CA9 : Étant donné un fichier source non couvert et présent parmi les 10 fichiers les plus souvent modifiés sur les 12 derniers mois (même calcul que `wf-analyse-projet`), alors son entrée a la priorité haute.
- CA10 : Étant donné un fichier source non couvert, absent de ce top 10, et contenant au moins une fonction ou méthode publique avec une branche conditionnelle (`if`, `switch`, opérateur ternaire, levée d'exception), alors son entrée a la priorité moyenne ; les autres fichiers non couverts ont la priorité faible.
- CA11 : Étant donné le livrable, alors « Tests manquants » est trié par priorité (haute, moyenne, faible) puis par nombre de commits sur 12 mois décroissant.
- CA12 : Étant donné un fichier sans logique exécutable (déclarations de types seules, configuration, fichier généré tel que `*.g.dart`, `*.freezed.dart` ou fichier portant un commentaire de génération), alors il n'apparaît pas dans « Tests manquants », et « Couverture actuelle » indique le nombre de fichiers ainsi exclus.
- CA13 : Étant donné une fonction couverte par au moins un test, mais dont une branche (cas d'erreur, levée d'exception, `else`) n'est déclenchée par aucune donnée d'entrée des tests existants, alors « Cas manquants dans le code testé » cite la fonction, le fichier, la ligne de la branche et le fichier de test existant, avec le statut « à vérifier ».
- CA14 : Étant donné le livrable, alors « Squelettes de tests » contient, pour chaque entrée de priorité haute, un bloc de code dans le langage et le framework de test du projet (ex. `describe`/`it` pour Vitest ou Jest, `group`/`test` ou `testWidgets` pour `flutter_test`), suivant les conventions de nommage et d'emplacement des tests existants, avec un cas par comportement identifié dans le code, et le chemin où le copier.
- CA15 : Étant donné un squelette de test, alors toute valeur attendue qui n'est pas directement déductible du code est remplacée par un marqueur explicite « à compléter » : aucune règle métier n'est inventée.
- CA16 : Étant donné un projet JS/TS sans aucun framework de test, alors « Outillage de test » l'indique et propose le framework le plus courant pour la stack détectée, présenté comme une suggestion à valider, et « Squelettes de tests » n'en contient aucun.
- CA17 : Étant donné un projet où aucun fichier source n'est non couvert et aucun cas manquant n'est identifié, alors les sections concernées l'indiquent et aucune entrée n'est inventée.
- CA18 : Étant donné un projet qui n'est pas un dépôt git, alors le critère de fréquence de modification (CA9) n'est pas appliqué, aucune entrée n'a la priorité haute à ce titre, et « Points non déterminés » le signale.
- CA19 : Étant donné un projet d'une stack non couverte en v1 (ex. PHP, Python), alors « Outillage de test » la signale « non couverte » et aucune entrée n'est produite pour elle ; dans un projet mixte, les parties JS/TS et Flutter sont analysées normalement.
- CA20 : Étant donné un livrable `docs/wf/tests-manquants.md` déjà présent, quand je relance l'outil, alors il est mis à jour au lieu d'être dupliqué : les entrées encore valables gardent leur identifiant, celles dont le test a été écrit depuis sont retirées, et un identifiant retiré n'est jamais réattribué.
- CA21 : Étant donné un projet contenant un fichier `.env*` autre que `.env.example`, alors l'outil ne lit pas ce fichier et le livrable ne contient aucune de ses valeurs.
- CA22 : Étant donné un répertoire vide ou sans code source, quand je lance l'outil, alors il l'indique et n'écrit aucun livrable.
- CA23 : Étant donné un monorepo (ex. FieldOps : application web JS/TS et application compagnon Flutter), alors « Outillage de test » et « Couverture actuelle » ont une sous-section par application, et chaque entrée de « Tests manquants » indique l'application concernée.
- CA24 : Étant donné une partie du code que l'outil n'a pas lue (projet volumineux), alors « Points non déterminés » liste les dossiers non lus, et aucune conclusion ne porte sur eux.

## Cas limites et erreurs

Couverts par CA6, CA12, et CA16 à CA24.

## Hors périmètre

- Diagnostic global de l'état du projet (c'est `wf-analyse-projet`).
- Écriture des fichiers de test dans le projet, exécution des tests et mesure de la couverture (lecture seule en v1, amendement 1 de l'ADR-001).
- Rapprochement entre les critères d'acceptation des specs du projet et ses tests.
- Recette fonctionnelle manuelle (c'est `wf-recette`).
- Tests de sécurité (c'est `wf-revue-securite`), de performance ou de charge.
- Correction des tests existants qui échouent.
- Stacks autres que JS/TS et Flutter en v1.

## Questions ouvertes

- Aucune.

## Amendement 1 (validé)

Précisions issues de l'implémentation, validées. Chacune complète le CA indiqué.

- CA3 : la commande de lancement suit le gestionnaire de paquets dont le lockfile est présent (npm, pnpm ou yarn) ; sans script de test dans `package.json`, la commande est « non déterminée ».
- CA4 : la commande `flutter test` est préfixée de `fvm` quand le projet fixe sa version de Flutter par fvm.
- CA5 : les rapports de couverture sont cherchés dans le dossier `coverage/` de chaque application, sur le disque, même s'ils sont ignorés par git ; un fichier source absent du rapport est réputé non couvert ; hors dépôt git, l'antériorité du rapport par rapport au dernier commit est « non déterminée ».
- CA8 : chaque entrée porte aussi une ligne « Commits sur 12 mois » (nombre de commits de l'étape de fréquence, 0 si le fichier n'y figure pas ; « non applicable (hors git) » hors dépôt git).
- CA8 : les noms à tester sont cités entre accents graves ; en Dart, est public tout nom qui ne commence pas par `_` ; un fichier sans export (script, point d'entrée) nomme l'élément exécuté à son chargement, avec la mention « non exporté ».
- CA8 : le type « bout en bout » n'est proposé que si un outil de test de bout en bout est déclaré dans le projet.
- CA9 : un fichier modifié par un seul commit sur 12 mois n'est pas un point chaud (même règle que `wf-analyse-projet`) ; le top 10 peut donc compter moins de 10 fichiers.
- CA10 : est publique une fonction exportée, une méthode publique d'une classe exportée ou un gestionnaire enregistré sur un objet exporté ; une branche située dans une fonction non exportée, une méthode privée ou une méthode d'une classe privée (en Dart, nom commençant par `_`, y compris la classe d'état d'un widget) ne rend pas le fichier prioritaire.
- CA11 : à priorité et nombre de commits égaux, les entrées sont triées par chemin.
- CA12 : sont aussi réputés générés les fichiers `*.gr.dart` et `*.mocks.dart`, et ceux dont l'en-tête porte `GENERATED CODE`, `@generated`, `DO NOT EDIT` ou `Code generated` ; « Couverture actuelle » donne les chemins des fichiers exclus en plus de leur nombre.
- CA13 : chaque cas manquant tient sur une ligne : fonction, fichier source et ligne de la branche, branche non déclenchée, fichier de test existant, statut « à vérifier ».
- CA14 : chaque squelette a pour titre « M<n> · à copier dans » suivi du chemin ; sans test existant dans l'application, le chemin suit la convention par défaut du framework.
- CA14 : un squelette n'importe aucune bibliothèque absente des dépendances du projet ; si le test en exige une, le besoin est signalé par un marqueur « à compléter ».
- CA16 : le framework suggéré est Vitest pour un projet qui utilise Vite, Jest sinon, sur une ligne « Suggestion à valider : <framework> (<raison tirée d'un fichier cité>) ».
- CA17 : les sections vides portent « Aucun fichier source sans test. », « Aucun cas manquant identifié. » et, dans « Squelettes de tests », la raison de l'absence de squelette ; l'en-tête porte alors « Dernier identifiant attribué : aucun ».
- CA20 : l'en-tête du livrable porte la ligne « Dernier identifiant attribué : M<n> », plus grand identifiant jamais attribué, y compris retiré depuis ; à la relance, les nouvelles entrées sont numérotées à partir du plus grand de cette valeur et des identifiants du livrable précédent ; à la première exécution, les entrées sont numérotées dans l'ordre de tri de CA11.
- CA22 : les messages sont « Le répertoire est vide : aucun livrable n'a été écrit. » et « Le répertoire ne contient aucun code source : aucun livrable n'a été écrit. » ; un répertoire qui contient un manifeste (`package.json`, `pubspec.yaml`…) n'est pas réputé sans code source.
- CA24 : le budget de lecture est d'environ 300 fichiers source des stacks couvertes ; au-delà, les dossiers les plus volumineux sont retirés de la lecture, du plus gros au plus petit ; hors de « Points non déterminés », une simple mention qu'ils n'ont pas été lus est permise.
- Cas limite : lancé dans un sous-dossier suivi d'un dépôt git, l'outil limite toute commande git à ce dossier et l'en-tête mentionne le sous-dossier ; un dossier situé sous un dépôt sans commit ou qui ne le suit pas est traité comme hors git.
- Cas limite : l'outil termine par un message court : chemin du livrable, nombre d'entrées par priorité, nombre de cas à vérifier, nombre de points non déterminés.
