# Spec 010 : wf-revue-securite, revue de sécurité du code et des dépendances

Statut : validée
Date : 2026-10-09

## Besoin

En tant que freelance qui livre, reprend ou maintient un projet web ou mobile, je veux une revue de sécurité approfondie de son code et de ses dépendances, afin de corriger les failles avant une livraison ou de les signaler au client avec des preuves.

`wf-analyse-projet` ne relève que les signaux de sécurité visibles ; cet outil va plus loin : chaque constat est rattaché à une catégorie OWASP, à un fichier et une ligne, et assorti d'une recommandation. Le livrable est à usage interne. Il suit l'ADR-001 et son amendement 1 (livrable, honnêteté, accès réseau, lecture seule, stacks couvertes).

## Critères d'acceptation

- CA1 : Étant donné un projet cible, quand je lance `/wf-revue-securite` à sa racine, alors le fichier `docs/wf/revue-securite.md` est créé et aucun autre fichier du projet n'est modifié.
- CA2 : Étant donné le livrable produit, alors il contient dans cet ordre les sections : Synthèse, Périmètre et méthode, Dépendances vulnérables, Constats dans le code, Secrets et configuration, Points non déterminés.
- CA3 : Étant donné le livrable, alors son en-tête comporte, en plus des mentions prévues par l'ADR-001, un avertissement indiquant qu'il est à usage interne, qu'il décrit des failles potentiellement non corrigées et qu'il ne doit pas être diffusé hors de l'équipe.
- CA4 : Étant donné le livrable, alors « Périmètre et méthode » indique le référentiel utilisé (OWASP Top 10 pour une application web, OWASP Mobile Top 10 pour une application Flutter, dans leur dernière édition publiée, citée avec son année), les applications et dossiers analysés, et rappelle qu'il s'agit d'une analyse statique de l'état courant du code, sans test d'intrusion, sans exécution du projet, sans analyseur externe et sans recherche dans l'historique git.
- CA5 : Étant donné une dépendance npm, pnpm, yarn ou pub dont la version installée est visée par au moins un avis de sécurité publié, alors « Dépendances vulnérables » la cite avec : identifiant `Sn`, nom, écosystème, version installée, identifiant de l'avis (CVE, GHSA ou OSV), sévérité publiée, première version corrigée (ou « aucune correction publiée »). L'avis est obtenu en interrogeant OSV.dev.
- CA6 : Étant donné un projet avec lockfile (`package-lock.json`, `pnpm-lock.yaml`, `yarn.lock` ou `pubspec.lock`), alors les dépendances transitives sont aussi vérifiées, et chaque dépendance vulnérable est marquée « directe » ou « transitive » ; pour une transitive, la dépendance directe qui l'introduit est citée.
- CA7 : Étant donné un projet sans lockfile, alors seules les dépendances directes sont vérifiées, sur la base des contraintes déclarées dans `package.json` ou `pubspec.yaml`, et « Points non déterminés » indique que les versions installées et les dépendances transitives n'ont pas pu être établies.
- CA8 : Étant donné OSV.dev injoignable, alors « Dépendances vulnérables » indique « non déterminé (base d'avis injoignable) », « Points non déterminés » le reprend, et le livrable est tout de même produit.
- CA9 : Étant donné le livrable, alors chaque entrée de « Constats dans le code » et de « Secrets et configuration » comporte : un identifiant `Sn`, un niveau (élevé, moyen, faible), la catégorie OWASP, au moins un fichier et numéro de ligne, une description factuelle, une recommandation, et un statut « confirmé » ou « à vérifier ».
- CA10 : Étant donné le niveau d'un constat dans le code, alors il suit cette grille : élevé si exploitable sans authentification, ou s'il expose un secret ou les données d'autres utilisateurs ; moyen si exploitable par un utilisateur authentifié ou sous une condition identifiée ; faible pour un durcissement sans exploitation identifiée. Pour les dépendances, la sévérité publiée est reprise telle quelle.
- CA11 : Étant donné un constat dont la réalité dépend d'un élément que l'outil n'a pas pu lire (configuration serveur, middleware global introuvable, variable d'environnement), alors son statut est « à vérifier » et la description nomme l'élément manquant.
- CA12 : Étant donné une requête SQL construite par concaténation ou interpolation d'une valeur non maîtrisée (ex. `"SELECT * FROM interventions WHERE id = " + req.params.id` dans l'API web de FieldOps, ou `db.rawQuery("... WHERE id = $id")` avec `sqflite` dans l'application Flutter), alors un constat de catégorie « injection » est émis avec le fichier et la ligne.
- CA13 : Étant donné une route d'API qui crée, modifie ou supprime des données sans contrôle d'authentification ou d'autorisation identifiable dans son code ou dans un middleware qui la couvre, alors un constat de catégorie « contrôle d'accès » est émis en citant la route, sa méthode HTTP et le fichier.
- CA14 : Étant donné une valeur littérale affectée à une variable ou une clé dont le nom contient `password`, `secret`, `token`, `apikey` ou `api_key` (casse ignorée) dans un fichier source `.js`, `.ts`, `.jsx`, `.tsx` ou `.dart` suivi par git, alors un constat de niveau élevé est émis avec le fichier et la ligne, et la valeur est remplacée par `[masqué]` : aucun caractère de la valeur ne figure dans le livrable.
- CA15 : Étant donné une application Flutter qui stocke un jeton ou un mot de passe avec `shared_preferences` (stockage non chiffré), alors un constat de catégorie « stockage non sécurisé » est émis avec le fichier et la ligne.
- CA16 : Étant donné un fichier `.env*` autre que `.env.example` suivi par git (présent dans `git ls-files`), alors « Secrets et configuration » émet un constat de niveau élevé citant son chemin, sans que l'outil ait lu son contenu.
- CA17 : Étant donné un projet contenant un fichier `.env*` autre que `.env.example`, alors l'outil ne lit pas ce fichier et le livrable ne contient aucune de ses valeurs.
- CA18 : Étant donné le livrable, alors « Synthèse » donne le nombre de constats par niveau, le nombre de dépendances vulnérables par sévérité publiée, et la liste des identifiants de niveau élevé ou de sévérité critique ou élevée.
- CA19 : Étant donné un projet où aucun constat ni aucune dépendance vulnérable n'est trouvé, alors les sections concernées indiquent « aucun constat », et « Synthèse » rappelle les limites de l'analyse (CA4) sans affirmer que le projet est sûr.
- CA20 : Étant donné un livrable `docs/wf/revue-securite.md` déjà présent, quand je relance l'outil, alors il est mis à jour au lieu d'être dupliqué : chaque constat ou dépendance vulnérable encore présent garde son identifiant `Sn`, ceux dont la cause a disparu sont retirés, et un nouveau reçoit un numéro supérieur au plus grand déjà attribué dans le livrable ; un identifiant retiré n'est jamais réattribué.
- CA21 : Étant donné le livrable, alors les identifiants `Sn` et le nom et le contenu de la section « Dépendances vulnérables » (CA5) forment un contrat au sens de l'amendement 1 de l'ADR-001 : `wf-montee-version` (spec 013) les lit, et les changer impose de mettre à jour cette spec.
- CA22 : Étant donné un projet d'une stack non couverte en v1 (ex. PHP, Python), alors « Périmètre et méthode » la signale « non couverte » et aucun constat ni aucune dépendance n'est rapporté pour elle ; dans un projet mixte, les parties JS/TS et Flutter sont analysées normalement.
- CA23 : Étant donné un répertoire vide ou sans code source, quand je lance l'outil, alors il l'indique et n'écrit aucun livrable.
- CA24 : Étant donné un monorepo (ex. FieldOps : application web JS/TS et application compagnon Flutter), alors chaque entrée `Sn` indique l'application concernée, et « Périmètre et méthode » liste les applications analysées avec le référentiel appliqué à chacune.
- CA25 : Étant donné une partie du code que l'outil n'a pas lue (projet volumineux), alors « Points non déterminés » liste les dossiers non lus, et aucune conclusion ne porte sur eux.

## Cas limites et erreurs

Couverts par CA7, CA8, CA11, CA16, CA17, CA19, et CA22 à CA25.

## Hors périmètre

- Diagnostic global de l'état du projet (c'est `wf-analyse-projet`).
- Plan de montée des dépendances vulnérables : l'outil indique la première version corrigée, le plan relève de `wf-montee-version`.
- Correction du code : l'outil recommande, il ne modifie rien.
- Test d'intrusion, analyse dynamique ou requête vers une instance du projet.
- Analyseurs statiques externes (Semgrep, gitleaks…) et recherche de secrets dans l'historique git.
- Mesure des en-têtes de sécurité d'un site en ligne (leur configuration dans le code reste dans le périmètre).
- Infrastructure hors dépôt (cloud, pare-feu, serveurs) et conformité légale (RGPD, certifications).
- Stacks autres que JS/TS et Flutter en v1.

## Questions ouvertes

- Aucune.

## Amendement 1 (proposé)

Précisions issues de l'implémentation, à valider. Chacune complète le CA indiqué.

- CA3 : l'en-tête porte aussi la ligne « Dernier identifiant attribué : Sn », ou « aucun » tant qu'aucun identifiant n'a été attribué.
- CA4 : le seul accès réseau est la lecture d'OSV.dev (avis de sécurité) et de pub.dev (dépendances déclarées d'un paquet pub) ; seuls des noms et versions de paquets et des identifiants d'avis sont envoyés.
- CA5 : une entrée `Sn` par couple (dépendance, avis). L'avis est identifié par son identifiant OSV, suivi de ses alias CVE. La sévérité publiée est le niveau de sévérité de l'avis, à défaut son vecteur CVSS, à défaut « non publiée ». Un avis dont les intervalles ne contiennent pas la version installée n'est pas retenu. npm, pnpm et yarn sont interrogés comme l'écosystème npm.
- CA5 : un nom, une version ou un identifiant d'avis lu dans le projet ou dans une réponse n'est jamais exécuté ni interprété par le shell, quel que soit son contenu ; une valeur qui contient un caractère hors lettres, chiffres et `@/._~+-` n'est pas vérifiée, et « Points non déterminés » le signale.
- CA5 : un paquet sans réponse de la base, ou dont la réponse est incomplète (paginée), est « non déterminé » et figure dans « Points non déterminés ».
- CA6 : pour une transitive pub, la dépendance directe qui l'introduit est établie d'après les dépendances déclarées des dépendances directes publiées sur pub.dev ; à défaut, l'entrée porte « transitive (introduite par : non déterminé) » et « Points non déterminés » le reprend.
- CA7 : sans lockfile, la version vérifiée est la plus basse admise par la contrainte déclarée ; la colonne de version indique « non déterminée » avec la contrainte et la version vérifiée. Une contrainte sans borne basse (toute version, dépôt git, chemin local) n'est pas vérifiée et figure dans « Points non déterminés ».
- CA8 : base d'avis injoignable à une relance : les entrées de dépendances du livrable précédent ne sont pas reconduites, et leurs identifiants ne sont jamais réattribués.
- CA9 : chaque entrée indique aussi son application ; la catégorie est un libellé en français (injection, contrôle d'accès, authentification, secret exposé, stockage non sécurisé, configuration, cryptographie, communication non sécurisée, intégrité, journalisation, gestion des erreurs) suivi de la catégorie OWASP correspondante du référentiel de l'application, selon une table fixe. Les secrets, fichiers d'environnement suivis et constats de configuration vont dans « Secrets et configuration », les autres dans « Constats dans le code ».
- CA11 : l'absence d'en-têtes de sécurité ou de politique CSP dans le code donne un constat « à vérifier », un proxy ou un serveur hors du dépôt pouvant les poser.
- CA13 : la route est citée complète, préfixe de montage compris ; une vérification d'appartenance manquante (un utilisateur authentifié qui agit sur la ressource d'un autre) est aussi signalée.
- CA14 : une valeur littérale donnée comme valeur par défaut d'un calcul compte comme valeur affectée ; la recommandation demande de sortir la valeur du code et de la renouveler.
- CA16 : si la liste des fichiers d'environnement suivis ne peut pas être obtenue de git (commande refusée par un garde-fou), l'outil se replie sur leurs seuls noms dans l'arborescence : leur suivi est alors non déterminé et le constat porte le statut « à vérifier ». Hors dépôt git, la vérification est « non applicable ».
- CA17 : les fichiers de secrets ou d'identifiants (configuration d'un gestionnaire de paquets, propriétés de signature, clés, certificats) ne sont pas lus non plus, et les recherches dans le code sont limitées aux extensions de code.
- CA18 : « Synthèse » donne le nombre de dépendances et le nombre d'avis, répartis par sévérité publiée, et porte toujours une ligne « Limites » qui rappelle CA4 et dit que l'analyse ne garantit pas l'absence de faille.
- CA19 : un projet sans aucune dépendance déclarée n'interroge pas la base ; « Dépendances vulnérables » porte « aucun constat ».
- CA20 : le prochain identifiant est supérieur au plus grand entre celui de la ligne « Dernier identifiant attribué » et le plus grand présent dans le livrable ; une entrée garde son identifiant si sa clé est inchangée (dépendance : écosystème, nom, avis ; constat : catégorie, fichier et code visé, la ligne pouvant changer).
- CA25 : le budget de lecture est d'environ 300 fichiers source, fichiers générés exclus ; au-delà, les dossiers les plus volumineux ne sont pas lus, et les recherches dans le code les excluent aussi.
- Cas limite : les commandes git de l'outil ne reçoivent aucune valeur venue du projet ou de l'utilisateur (pas de référence, de branche ni de chemin fournis).
