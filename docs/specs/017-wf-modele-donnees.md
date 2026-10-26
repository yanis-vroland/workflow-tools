# Spec 017 : wf-modele-donnees, modèle de données et schéma de base

Statut : validée
Date : 2026-10-12

## Besoin

En tant que chef de projet ou développeur freelance, je veux passer d'une analyse (cadrage, cahier des charges, transcription) à un modèle de données, puis à un schéma de base de données, et faire évoluer un schéma existant, afin de cadrer les données avec le client et de livrer au développeur une base cohérente et justifiée.

Le livrable s'adresse au chef de projet pour le modèle conceptuel, qu'il peut partager avec le client, et au développeur pour le schéma physique et les migrations. Il suit l'ADR-001 et ses amendements 1 (entrées hors du code, saisies humaines, écriture limitée à `docs/wf/`) et 2 (fichiers non Markdown, aucune exécution, encadrés « À décider »).

### Trois niveaux

| Niveau | Entrée | Sortie |
| --- | --- | --- |
| **A. Modèle conceptuel** | Une analyse : fichiers passés en argument, ou `docs/wf/cadrage-besoin.md` s'il existe | Entités, attributs, relations, règles de gestion, questions au client, décisions à prendre |
| **B. Schéma physique** | Le modèle A dont les questions bloquantes et les décisions sont remplies | Schéma, première migration, données de test fictives, requêtes de vérification |
| **C. Évolution** | Une nouvelle demande et un schéma existant dans le projet | Différences, migration sans perte, impacts sur le code |

### Entrée et choix du niveau

```
/wf-modele-donnees brief-fieldops.md notes-appel.md
/wf-modele-donnees --niveau b
```

- Les sources sont des fichiers Markdown, texte ou PDF contenant du texte, comme pour `wf-cadrage-besoin` (spec 004). Sans argument, l'outil lit `docs/wf/cadrage-besoin.md` s'il existe ; avec des arguments, il ne lit que ceux-ci.
- Un schéma existant est détecté dans le projet : fichier SQL contenant des `CREATE TABLE`, `schema.prisma`, entités TypeORM, tables Drift, ou création de tables par sqflite.
- Sources fournies, aucun schéma détecté : niveau A. Relance sans argument d'un livrable au niveau A : niveau B si toutes les questions bloquantes et toutes les décisions sont remplies, sinon mise à jour du niveau A.
- Sources fournies et schéma détecté : niveau C.
- `--niveau a|b|c` force le niveau.
- L'outil ne pose aucune question pendant l'exécution : il écrit ses questions et ses décisions dans le livrable, je les remplis à la main puis je relance.

### Stacks couvertes en v1

- Web : SQL PostgreSQL, Prisma, TypeORM. Mobile : Drift et sqflite (SQL SQLite, migration par montée de version de la base).
- Sans ORM détecté (projet sans code, ou SQL écrit à la main), le niveau B produit du SQL PostgreSQL.
- Les autres ORM et bases (Sequelize, Knex, Drizzle, Mongoose…) sont détectés et signalés « non couverts ».

### Livrable

Le livrable est le dossier `docs/wf/modele-donnees/` (ADR-001, amendement 2) :

- `index.md` : en-tête, niveau atteint, et les sections Synthèse, Modèle conceptuel, Dictionnaire de données, Règles de gestion, Questions au client, À décider, Revue du modèle, puis selon le niveau Schéma physique et Preuve par les cas d'usage (B) ou Évolution (C), et enfin Points non déterminés.
- Au niveau B en SQL PostgreSQL : `schema.sql` (création complète, qui sert de première migration), `donnees-test.sql` et `requetes.sql`. Avec un ORM : le schéma et la première migration au format de l'ORM et de son outil de migration, plus `donnees-test.sql` et `requetes.sql`.
- Au niveau C : la migration au format de l'outil de migration détecté, ou `migration.sql` à défaut.
- Le schéma physique suit des conventions fixes : noms en `snake_case` et en anglais, clé primaire `id`, clé étrangère `<table au singulier>_id`, colonnes `created_at` et `updated_at`. Au niveau C, la migration suit les conventions du schéma existant, et les écarts entre ce schéma et les conventions sont signalés dans « Revue du modèle ».

### Contrat avec les autres outils

L'outil lit `docs/wf/cadrage-besoin.md` (spec 004) : sa section « Besoins fonctionnels » et ses identifiants `Bnn`, déjà contractuels.

## Critères d'acceptation

### Commun

- CA1 : Étant donné un projet cible et un fichier source lisible, quand je lance `/wf-modele-donnees <chemin>` à sa racine, alors le dossier `docs/wf/modele-donnees/` est créé avec un `index.md`, et aucun fichier hors de ce dossier n'est créé ni modifié, y compris les sources.
- CA2 : Étant donné le livrable, alors l'en-tête de `index.md` est conforme à l'ADR-001, indique le niveau atteint (A, B ou C), et liste les sources lues par leur chemin relatif à la racine du projet, jamais par un chemin absolu ; ailleurs, une source est désignée par son nom de fichier seul.
- CA3 : Étant donné le livrable, alors `index.md` contient dans l'ordre les sections : Synthèse, Modèle conceptuel, Dictionnaire de données, Règles de gestion, Questions au client, À décider, Revue du modèle, puis Schéma physique et Preuve par les cas d'usage au niveau B, ou Évolution au niveau C, et enfin Points non déterminés.
- CA4 : Étant donné le livrable, alors chaque entité, attribut et relation cite la phrase source (entre guillemets, avec le nom du fichier et le titre de section ou la page, ou l'identifiant `Bnn`), ou est marqué « supposé » s'il n'en a aucune.
- CA5 : Étant donné « Modèle conceptuel », alors il contient un bloc Mermaid `erDiagram` qui reprend toutes les entités et relations, avec leurs cardinalités.
- CA6 : Étant donné « Dictionnaire de données », alors chaque attribut y figure dans un tableau `Entité | Champ | Type | Obligatoire | Exemple | Source`, et chaque exemple est fictif.
- CA7 : Étant donné « Règles de gestion », alors chaque règle a un identifiant unique (`RG01`, `RG02`…) et une source ; chaque cardinalité du modèle découle d'une règle ou est marquée « supposé ».
- CA8 : Étant donné « Questions au client », alors chaque question suit le format de la spec 004 (`Q01`…, champ « Réponse : » vide à remplir à la main), cite la phrase source qui la motive, et indique si elle est bloquante pour le schéma physique.
- CA9 : Étant donné un choix de modélisation que les sources ne tranchent pas (ex. suppression définitive ou désactivation d'un technicien), alors « À décider » contient un encadré conforme à l'amendement 2 de l'ADR-001 (`Dnn`, contexte sourcé, au moins deux options avec leurs conséquences, champ « Décision : » vide), et l'outil n'en recommande aucune.
- CA10 : Étant donné un livrable dont j'ai rempli des champs « Réponse : » ou « Décision : », quand je relance l'outil, alors ces saisies sont conservées telles quelles, et les éléments qu'elles tranchent les citent comme source (« réponse saisie à la question `Qnn` », « décision saisie en `Dnn` »).
- CA11 : Étant donné un livrable existant, quand je relance l'outil, alors une entité, une règle, une question ou une décision conserve son identifiant, et l'identifiant d'un élément retiré n'est jamais réattribué.
- CA12 : Étant donné des sources ou un schéma contenant des données personnelles (nom, e-mail, téléphone, adresse, position géographique), alors « Revue du modèle » liste chaque champ personnel concerné, avec une durée de conservation « à préciser » si aucune source ne la fixe.
- CA13 : Étant donné une source contenant des adresses e-mail, des numéros de téléphone ou des noms de personnes, alors aucun n'apparaît dans le livrable, ni dans les exemples, ni dans les données de test.
- CA14 : Étant donné le livrable, alors « Revue du modèle » signale chaque attribut « supposé », chaque nommage incohérent (même notion nommée différemment, mélange de langues ou de casses) et, au niveau B, chaque relation n-n sans table de jointure.
- CA15 : Étant donné toute exécution de l'outil, alors aucune commande n'exécute une requête, une migration, un client de base de données ou un outil d'ORM (`psql`, `prisma migrate`, `typeorm migration:run`…), et le livrable indique que les fichiers produits n'ont pas été exécutés.
- CA16 : Étant donné le livrable, alors chaque fichier non Markdown du dossier est listé dans `index.md` avec son rôle, et commence par un commentaire qui nomme l'outil et renvoie à `index.md`.

### Niveau A

- CA17 : Étant donné le répertoire de la fixture `tests/fixtures/fieldops-brief/` (projet sans code source), quand je lance l'outil avec `brief-fieldops.md` et `notes-appel.md`, alors le livrable atteint le niveau A, contient au moins les entités intervention, technicien et client, et aucun fichier non Markdown.
- CA18 : Étant donné un projet contenant `docs/wf/cadrage-besoin.md` et aucun schéma, quand je lance l'outil sans argument, alors le livrable atteint le niveau A et ses sources citent les identifiants `Bnn` de ce fichier.

### Niveau B

- CA19 : Étant donné un livrable au niveau A dont toutes les questions bloquantes et toutes les décisions sont remplies, quand je relance l'outil sans argument, alors le livrable atteint le niveau B et contient, sans ORM détecté, `schema.sql`, `donnees-test.sql` et `requetes.sql`.
- CA20 : Étant donné un livrable au niveau A dont une question bloquante ou une décision reste vide, quand je relance l'outil sans argument, alors le niveau A est mis à jour, aucun fichier de schéma n'est écrit, et la Synthèse liste les questions et décisions qui manquent pour passer au niveau B.
- CA21 : Étant donné ce même livrable, quand je relance avec `--niveau b`, alors le niveau B est produit, et chaque élément qui dépend d'une question ou d'une décision vide est marqué « supposé » dans le schéma (commentaire) et dans `index.md`.
- CA22 : Étant donné le schéma physique, alors il respecte les conventions fixes de cette spec, déclare une clé étrangère pour chaque relation, une contrainte `CHECK` pour chaque ensemble fini de valeurs issu d'une règle de gestion (ex. les statuts d'une intervention), et chaque index autre qu'une clé primaire ou une contrainte d'unicité est justifié par une requête de `requetes.sql` ou une règle `RGnn`.
- CA23 : Étant donné « Preuve par les cas d'usage », alors chaque besoin des sources y figure avec la requête de `requetes.sql` qui y répond, commentée et rattachée au besoin ; un besoin sans requête possible est signalé comme un défaut du schéma dans « Revue du modèle ».
- CA24 : Étant donné `donnees-test.sql`, alors ses données sont fictives, respectent les contraintes du schéma (clés étrangères, `CHECK`, `NOT NULL`) et permettent à chaque requête de `requetes.sql` de renvoyer au moins une ligne.
- CA25 : Étant donné un projet utilisant Prisma, TypeORM, Drift ou sqflite, quand l'outil atteint le niveau B, alors le schéma et la première migration sont au format de cet ORM et de son outil de migration, et non en SQL PostgreSQL.

### Niveau C

- CA26 : Étant donné la fixture `tests/fixtures/fieldops/`, quand je lance l'outil avec `../fieldops-brief/notes-appel.md`, alors le livrable atteint le niveau C, et « Évolution » cite chaque schéma détecté (`src/db/schema.sql` en PostgreSQL, `mobile/lib/db/local_db.dart` en sqflite) avec son ORM et son outil de migration, ou « aucun » s'il n'y en a pas.
- CA27 : Étant donné le niveau C, alors « Évolution » liste les différences entre le schéma existant et le modèle demandé (tables et colonnes ajoutées, modifiées, renommées, supprimées), chacune avec sa source.
- CA28 : Étant donné une colonne `NOT NULL` ajoutée à une table existante, alors la migration lui donne une valeur par défaut ou la remplit par une reprise avant d'imposer la contrainte, jamais une contrainte seule.
- CA29 : Étant donné une colonne ou une table renommée, alors la migration la renomme, et ne la supprime pas pour la recréer.
- CA30 : Étant donné une suppression de colonne ou de table, alors elle n'est écrite dans la migration qu'une fois une décision `Dnn` saisie qui la confirme ; avant, elle fait l'objet d'un encadré « À décider » et la migration ne la contient pas.
- CA31 : Étant donné le niveau C, alors « Évolution » liste chaque fichier du code qui utilise une table ou une colonne modifiée, avec son chemin et l'élément utilisé.
- CA32 : Étant donné un projet dont le schéma est versionné par sqflite, alors la migration prévoit l'incrément de version de la base et le code de montée de version, écrits dans le livrable.

## Cas limites et erreurs

- CA33 : Étant donné aucun argument, aucun `docs/wf/cadrage-besoin.md` et aucun livrable existant, quand je lance l'outil, alors il indique la syntaxe attendue et n'écrit aucun livrable.
- CA34 : Étant donné `--niveau c` sans schéma détecté, ou une valeur de `--niveau` autre que `a`, `b` ou `c`, quand je lance l'outil, alors il l'indique et n'écrit aucun livrable.
- CA35 : Étant donné un chemin qui n'existe pas, un format autre que Markdown, texte ou PDF, ou un PDF sans texte extractible, alors l'outil se comporte comme `wf-cadrage-besoin` (spec 004, CA17) : il nomme le fichier en cause, n'écrit rien si aucune source n'est lisible, sinon continue et le signale dans « Points non déterminés ».
- CA36 : Étant donné un ORM ou une base non couverts, quand l'outil atteint le niveau B ou C, alors il le signale, produit le modèle conceptuel et, au niveau C, les différences et les impacts, mais aucun fichier de schéma ni de migration.
- CA37 : Étant donné un fichier de `docs/wf/modele-donnees/` qui n'a plus lieu d'être à la relance (ex. ancienne migration de niveau C), alors l'outil ne le supprime pas et le signale dans `index.md`.
- CA38 : Étant donné un projet contenant des fichiers `.env*` autres que `.env.example`, alors ils ne sont pas lus, et aucune chaîne de connexion à une base n'est recopiée dans le livrable.

## Hors périmètre

- Exécution des requêtes, des migrations ou des données de test, y compris dans une base jetable (ADR-001, amendement 2).
- Copie des fichiers produits dans le projet : le développeur le fait lui-même.
- Bases non relationnelles et ORM non listés dans les stacks couvertes.
- Optimisation fine des performances (partitionnement, plans d'exécution) et réglage du serveur.
- Cadrage du besoin lui-même (c'est `wf-cadrage-besoin`) et découpage en tickets (c'est `wf-specs-tickets`).
- Entretien interactif pendant l'exécution.

## Construction et evals

- Implémentation en trois PR successives : niveau A, puis B, puis C, chacune avec ses tests structurels et au moins un cas d'eval sur FieldOps (CA17 pour A, CA19 pour B à partir d'un livrable A rempli, CA26 pour C).
- Les fixtures existantes suffisent : `tests/fixtures/fieldops-brief/` pour A et B, `tests/fixtures/fieldops/` (`src/db/schema.sql`, `mobile/lib/db/local_db.dart`) pour C.

## Questions ouvertes

- Après la v1 : mesure chiffrée de la qualité du modèle sur 3 à 5 briefs fictifs dont le schéma attendu est connu.

## Amendement 1 (validé)

Précisions issues de l'implémentation, validées. Chacune complète le CA indiqué.

- CA1 : l'outil ne supprime, ne déplace ni ne renomme aucun fichier, même dans `docs/wf/modele-donnees/`, et ne crée aucun fichier temporaire.
- CA2 : l'en-tête de `index.md` comporte, en plus de l'outil, de la date et du commit, les lignes « Niveau atteint » (A, B ou C, avec la mention « forcé par --niveau » le cas échéant), « Sources lues », « Derniers identifiants attribués » et « Exécution ».
- CA4 : une source se cite sous la forme « phrase » (fichier, « titre de section ») pour un fichier Markdown ou texte, « phrase » (fichier, page N) pour un PDF, l'identifiant `Bnn` pour un besoin du cadrage, « réponse saisie à la question `Qnn` » ou « décision saisie en `Dnn` » pour une saisie.
- CA4 : un élément sans source n'est ajouté comme « supposé » que s'il est indispensable à l'entité qui le porte.
- CA4 : chaque relation porte sa propre source (phrase citée, identifiant de besoin ou saisie) ou la marque « supposé », même quand la règle dont découlent ses cardinalités est elle-même sourcée.
- CA5 : les noms d'entités du diagramme sont en majuscules, sans accent ni espace.
- CA7 : chaque relation indique la règle `RGnn` dont découlent ses cardinalités.
- CA8 : chaque question se termine par « Bloquante : oui » ou « Bloquante : non » ; une question est bloquante si sa réponse change une table, une colonne, une clé, une cardinalité ou une contrainte du schéma physique.
- CA9 : chaque élément du modèle qui dépend d'un encadré non décidé (entité, attribut, ligne du dictionnaire, relation, règle), y compris celui que le modèle représente faute de décision, porte la mention « provisoire, voir `Dnn` » ; chaque encadré est ainsi renvoyé par au moins un élément, et une fois la décision saisie la mention devient « décision saisie en `Dnn` ».
- CA10 : un champ « Réponse : » vide n'est rempli que si une source nouvelle donne explicitement la réponse, suivie de cette source ; un champ « Décision : » n'est jamais rempli par l'outil. Si le contexte d'un encadré décidé a changé, la décision est conservée et le changement signalé sous l'encadré.
- CA11 : les entités portent un identifiant `Enn`. La ligne d'en-tête « Derniers identifiants attribués » donne les plus grands `Enn`, `RGnn`, `Qnn` et `Dnn` jamais attribués, y compris retirés ; un nouvel élément reçoit le plus grand identifiant connu (ligne d'en-tête ou livrable) plus un.
- CA12 : sont aussi des données personnelles la photo d'une personne ou d'un domicile et l'identifiant de compte ; au niveau C, les champs personnels du schéma existant sont listés comme ceux du modèle.
- CA13 : une personne citée par les sources est désignée par son rôle ; un exemple d'adresse e-mail, s'il en faut un, est inventé dans un domaine réservé aux tests.
- CA14 : « Revue du modèle » comporte les sous-sections « Données personnelles », « Éléments supposés » et « Nommage incohérent », plus au niveau B « Relations n-n sans table de jointure » et « Défauts du schéma », et au niveau C « Écarts aux conventions ».
- CA15 : Bash ne sert qu'à lire la date, le commit et l'état git, à extraire le texte d'un PDF, à calculer un chemin relatif (chemin passé par l'entrée standard, jamais dans la ligne de commande) et à créer les dossiers du livrable ; toute recherche dans le projet passe par les outils de lecture, jamais par Bash.
- CA16 : le commentaire d'en-tête d'un fichier non Markdown est « Généré par wf-modele-donnees : voir index.md (fichier non exécuté). » ; les fichiers sont listés dans un tableau « Fichier | Rôle ».
- CA18 : sans argument, seul `docs/wf/cadrage-besoin.md` est lu, pas les fichiers qu'il cite ; ses besoins se citent par leur identifiant.
- CA19 et CA20 : le passage au niveau B se décide sur les champs du livrable existant, avant sa mise à jour ; une relance sans argument d'un livrable au niveau B reste au niveau B.
- CA21 : au niveau B forcé, chaque point non tranché reçoit l'hypothèse la plus simple compatible avec les sources, sans être présentée comme recommandée, et l'élément porte en commentaire « supposé : voir `Qnn` » (ou `Dnn`) dans le schéma.
- CA22 : les tables sont nommées au pluriel ; chaque index est précédé d'un commentaire « Justification : » qui cite une requête `Rnn` ou une règle `RGnn` ; le schéma est en troisième forme normale, toute dérogation justifiée en commentaire.
- CA23 : chaque requête de `requetes.sql` est en lecture seule, identifiée `Rnn` et précédée d'un commentaire qui nomme le besoin et sa source.
- CA25 : fichiers produits par ORM : Prisma, `schema.prisma` et `migrations/<horodatage>_init/migration.sql` ; TypeORM, `entities/<nom>.entity.ts` et `migrations/<horodatage>-Init.ts` ; Drift, `tables.dart` et `database.dart` ; sqflite, `local_database.dart` ; données de test et requêtes dans le dialecte de la base. Avec plusieurs ORM couverts, les fichiers de chacun vont dans un sous-dossier nommé d'après l'ORM. L'ORM est détecté par les dépendances des manifestes du projet.
- CA26 : « Évolution » présente les schémas détectés dans un tableau « Schéma | Base ou ORM | Outil de migration » ; la migration d'une base sqflite est écrite dans `migration-sqflite.dart`, celle d'une base Drift dans `migration-drift.dart`, celle d'un dossier de migrations SQL numérotées sous le numéro suivant, selon la même convention ; la détection de schéma ignore `docs/wf/`, les dépendances installées et les dossiers de build.
- CA26 : une relance sans argument d'un livrable au niveau C reste au niveau C tant qu'un schéma est détecté.
- CA30 : une suppression non confirmée n'apparaît nulle part dans la migration, pas même en commentaire ; « Évolution » la présente « en attente de `Dnn` ».
- CA31 : chaque fichier cité est trouvé par une recherche du nom de la table ou de la colonne limitée aux fichiers de code, puis lu ; aucun fichier d'environnement n'est ouvert.
- CA35 : l'existence d'un fichier se vérifie sans commande shell ; un PDF dont le chemin contient une apostrophe, ou un argument écrit sur plusieurs lignes, est écarté sans commande avec sa raison ; un chemin relatif passé à l'extraction PDF est préfixé par `./`.
- CA36 : les ORM non couverts reconnus sont au moins Sequelize, Knex, Drizzle, Mongoose, MikroORM, Objection, Isar, Hive, Floor et ObjectBox ; au niveau B, le niveau atteint reste B, avec la mention « ORM non couvert ».
- CA37 : un fichier sans objet est signalé dans « Points non déterminés » comme n'ayant plus lieu d'être, sans être réécrit.
- CA38 : la recherche dans le projet n'affiche jamais le contenu d'un fichier avant de savoir s'il est un fichier d'environnement (recherche par liste de fichiers, puis lecture des seuls fichiers autorisés) ; `.env.example` n'est pas une source d'analyse ; un fichier Prisma nomme la variable de connexion, jamais sa valeur.
- Cas limite : en relance, une source de l'en-tête située hors du projet n'est pas relue sans être repassée en argument ; elle reste dans « Sources lues », est signalée dans « Points non déterminés », et les éléments qui en dépendaient sont conservés.
