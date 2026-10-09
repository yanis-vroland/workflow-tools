# Spec 003 : wf-onboarding, guide de prise en main pour un nouvel arrivant

Statut : brouillon
Date : 2026-10-09

## Besoin

En tant que freelance qui fait entrer un développeur sur un projet en cours (renfort, sous-traitant, développeur du client), je veux générer un guide pas à pas qui le mène de zéro à sa première contribution, afin de réduire le temps que je passe à l'accompagner et les questions répétées.

Le livrable s'adresse à un développeur qui rejoint le projet, pendant que l'équipe en place reste disponible. Il répond à la question « que dois-je faire, dans quel ordre, pour être opérationnel ? ». Il se distingue de :

- `wf-doc-projet`, qui décrit le système (« comment est-il construit ? ») pour l'équipe ou le client, sans ordre de lecture ni parcours ;
- `wf-passation`, qui organise le transfert de responsabilité quand le prestataire part (« que dois-je recevoir pour assumer le projet seul ? »).

Le guide doit pouvoir être suivi seul : il reprend donc les commandes d'installation et de lancement, aussi présentes dans la section « Installation et lancement » de `wf-doc-projet`. Ce recouvrement est assumé et limité à ces commandes.

Il suit les conventions de l'ADR-001 et de son amendement 1 (fichier unique mis à jour, écriture limitée à `docs/wf/`, aucune exécution du projet, stacks couvertes en v1).

## Critères d'acceptation

- CA1 : Étant donné un projet cible, quand je lance `/wf-onboarding` à sa racine, alors le fichier `docs/wf/onboarding.md` est créé et aucun autre fichier du projet n'est modifié.
- CA2 : Étant donné le livrable produit, alors il contient dans cet ordre les sections : Avant de commencer, Installer le projet, Lancer le projet, Vérifier l'installation, Se repérer dans le code, Contribuer, Glossaire métier, Pour aller plus loin, Points non déterminés.
- CA3 : Étant donné un projet qui fixe des versions d'outils (ex. `.nvmrc`, `.tool-versions`, champ `engines` de `package.json`, `Dockerfile`, contrainte `environment` de `pubspec.yaml`), alors « Avant de commencer » liste chaque outil requis avec sa version et le fichier d'où elle provient. Un outil requis dont aucune version n'est fixée porte la mention « version non déterminée ».
- CA4 : Étant donné le livrable, alors « Installer le projet », « Lancer le projet » et « Vérifier l'installation » sont rédigées en étapes numérotées, chaque étape donnant une commande exacte tirée d'un fichier du projet (scripts de `package.json`, `Makefile`, `docker-compose.yml`, README…) dont le chemin est cité.
- CA5 : Étant donné un projet qui définit des tests, alors « Vérifier l'installation » donne la commande de lancement des tests tirée des fichiers du projet. Sans commande de test identifiable, la section l'indique et « Points non déterminés » le reprend.
- CA6 : Étant donné un projet qui utilise des variables d'environnement, alors « Installer le projet » contient une étape de configuration qui liste leurs noms (tirés de `.env.example` ou du code), sans aucune valeur et dans le respect des règles de l'ADR-001 sur les fichiers `.env*`.
- CA7 : Étant donné un projet qui propose à la fois une installation par conteneurs (ex. `docker-compose.yml`) et une installation native, alors les étapes décrivent une seule voie principale, celle que décrit le README ou, à défaut, la voie par conteneurs, et l'autre voie est mentionnée en une ligne avec le fichier qui la définit.
- CA8 : Étant donné le livrable, alors « Se repérer dans le code » propose un parcours de lecture de 5 à 10 fichiers, numérotés dans l'ordre de lecture conseillé, en commençant par le point d'entrée de l'application. Chaque fichier est cité par son chemin, avec une phrase qui dit ce qu'on y apprend.
- CA9 : Étant donné un projet qui contient des conventions de contribution (`CONTRIBUTING.md`, configuration de lint ou de format, hooks git, configuration de CI, modèle de PR), alors « Contribuer » les résume en citant chaque fichier source : nommage des branches, format des commits, commandes de lint et de format, vérifications de CI à passer.
- CA10 : Étant donné un projet sans aucun des fichiers cités en CA9, alors « Contribuer » indique « aucune convention de contribution trouvée dans le dépôt », « Points non déterminés » le reprend, et aucune convention n'est inventée.
- CA11 : Étant donné le livrable, alors « Glossaire métier » liste au plus 20 termes du domaine, tirés des noms d'entités, de modèles ou de tables (ex. pour FieldOps : `Intervention`, `Technician`, `WorkOrder`), chacun avec le fichier où il est défini. Un terme dont le sens n'est établi par aucun fichier (code, commentaire, documentation) porte la mention « définition non déterminée ».
- CA12 : Étant donné un livrable de `wf-doc-projet` présent (`docs/wf/doc-projet.md` ou `docs/wf/doc-projet/index.md`), alors « Pour aller plus loin » y renvoie par un lien relatif et nomme ses sections « Architecture », « Fonctionnalités » et « Structure du code » (en format dossier : `index.md`, `fonctionnalites.md` et `structure.md`) comme suite de lecture. Sans ce livrable, la section le signale et suggère de lancer `/wf-doc-projet`.
- CA13 : Étant donné le livrable, alors il ne contient ni schéma d'architecture, ni description exhaustive des fonctionnalités (relevant de `wf-doc-projet`), ni jugement de qualité, dette ou risque (relevant de `wf-analyse-projet`).
- CA14 : Étant donné le livrable, alors une mention en tête de guide précise qu'il a été établi par lecture des fichiers, sans exécution des commandes, et que les étapes n'ont donc pas été vérifiées.
- CA15 : Étant donné le livrable, alors son en-tête est conforme à l'ADR-001 (outil, date, commit ou « hors git », mention « modifications non commitées » le cas échéant).
- CA16 : Étant donné un livrable `docs/wf/onboarding.md` déjà présent, quand je relance l'outil, alors il est mis à jour selon l'ADR-001 au lieu d'être dupliqué.
- CA17 : Étant donné un répertoire vide ou sans code source, quand je lance l'outil, alors il l'indique et n'écrit aucun livrable.
- CA18 : Étant donné un projet dont la stack n'est couverte ni par JavaScript/TypeScript ni par Flutter, alors le guide est produit à partir du README et des fichiers génériques (`Makefile`, `Dockerfile`, `docker-compose.yml`, CI), l'en-tête indique « stack <nom> non couverte en v1 », et « Points non déterminés » liste les sections qui n'ont pas pu être établies.
- CA19 : Étant donné un projet sans commande de lancement identifiable, alors « Lancer le projet » le dit, « Points non déterminés » le reprend, et aucune commande n'est inventée.
- CA20 : Étant donné un projet dont le README contredit les fichiers de configuration (ex. une commande absente des scripts), alors le guide suit les fichiers de configuration, l'écart est décrit dans « Points non déterminés » en citant le README et le fichier qui le contredit, et le README n'est pas modifié.
- CA21 : Étant donné un monorepo (ex. FieldOps : application web et application compagnon Flutter), alors « Installer le projet », « Lancer le projet » et « Vérifier l'installation » contiennent une sous-section par application, et « Avant de commencer » regroupe les prérequis de toutes les applications.
- CA22 : Étant donné le livrable, alors il ne contient aucune adresse e-mail de contributeur ni aucune valeur de secret.

## Cas limites et erreurs

Couverts par CA5, CA10, CA11 (terme sans définition), CA12 (doc-projet absente) et CA17 à CA21.

## Hors périmètre

- Description du système : architecture, stack détaillée, fonctionnalités (c'est `wf-doc-projet`).
- Recouvrement assumé avec `wf-doc-projet` et `wf-passation` : les commandes d'installation et les écarts entre README et code figurent dans plusieurs livrables, qui doivent pouvoir se lire seuls.
- Diagnostic, dette et risques (c'est `wf-analyse-projet`).
- Transfert de responsabilité, d'accès et de comptes en fin de mission (c'est `wf-passation`).
- Guide d'utilisation de l'application pour un profil non technique.
- Procédure de déploiement (couverte par `wf-passation`).
- Exécution des commandes du guide, installation des dépendances ou création du fichier d'environnement du lecteur.
- Proposition d'une première tâche à réaliser (dépend du backlog, absent du dépôt).

## Questions ouvertes

- Les bornes de 5 à 10 fichiers (CA8) et de 20 termes (CA11) sont des propositions, à ajuster après les premiers essais sur de vrais projets.
