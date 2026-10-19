---
name: wf-specs-tickets
description: Découpe un besoin cadré (docs/wf/cadrage-besoin.md de wf-cadrage-besoin, ou un fichier de besoin passé en argument) en tickets prêts à développer dans docs/wf/specs-tickets.md - récit utilisateur, critères d'acceptation « Étant donné, quand, alors » numérotés, dépendances et ordre de réalisation avec schéma Mermaid, tâches du chiffrage reprises sans réestimer, fichiers concernés, points à clarifier. Markdown générique à coller dans GitHub, GitLab ou tout outil de suivi ; ne crée aucun ticket dans un outil. À utiliser pour démarrer la réalisation d'un besoin cadré ou mettre à jour les tickets après un nouveau cadrage.
argument-hint: "[<fichier de besoin>]"
---

# wf-specs-tickets

Tu découpes un besoin cadré en tickets prêts à développer, dans le livrable `docs/wf/specs-tickets.md` du projet courant. Ce livrable est lu par `wf-rapport-avancement` et `wf-recette` : son chemin, les noms de ses sections, les noms des rubriques de ticket, les identifiants de tickets `Tnn` et les numéros de critères `CAn` (cités ailleurs sous la forme `T03-CA2`) sont un contrat, à respecter à la lettre.

Arguments de la commande (vide si aucun) : $ARGUMENTS

## Règles permanentes

- **Aucune question pendant l'exécution** : tout ce qui est à clarifier va dans le livrable. Ne demande jamais de confirmation.
- **Écriture** : le seul fichier que tu écris est `docs/wf/specs-tickets.md` (tu peux créer le dossier `docs/wf/`). Tu ne modifies jamais les livrables des autres outils (`docs/wf/cadrage-besoin.md`, `docs/wf/chiffrage.md`), ni le fichier de besoin, ni le code, ni quoi que ce soit d'autre dans le projet. Aucun fichier temporaire, pas de branche, pas de commit. Écris uniquement avec Write, jamais avec Edit ni avec une commande Bash.
- **Aucun outil de suivi** : tu ne crées, ne modifies ni ne synchronises aucun ticket dans un outil de suivi (GitHub Issues, GitLab, Jira, Linear…), et tu ne te connectes à aucun service : ni `gh`, ni `glab`, ni `curl`, ni accès réseau. Les tickets sont du Markdown générique, à coller tel quel par l'utilisateur.
- **Commandes Bash autorisées**, recopiées telles quelles, chacune seule, sans enchaînement ni texte ajouté : `date +%F`, `git rev-parse --short HEAD`, `git status --porcelain -- . ':(exclude)docs/wf'` et `mkdir -p docs/wf`. Aucune autre commande, et jamais un argument, un nom de fichier ou un texte lu inséré dans une commande : pour savoir si un fichier existe, utilise Glob avec son chemin exact (ou Read, dont l'erreur « fichier inexistant » vaut absence) ; pour lire et chercher, Read, Glob et Grep. Tu n'exécutes ni le projet, ni ses tests, ni son installation.
- **Fichiers d'environnement** : un fichier dont le nom commence par `.env` (`.env`, `.env.local`, `.env.md`…) n'est jamais ouvert ni cité dans une commande, quelle que soit son extension ; seul `.env.example` pourrait être lu, et il n'est d'aucune utilité ici. Aucune valeur d'un tel fichier n'apparaît dans le livrable. Grep s'utilise uniquement en mode `files_with_matches` (liste de fichiers, jamais de lignes), pour qu'aucune ligne d'un fichier d'environnement ne s'affiche ; écarte ces fichiers des résultats de Glob et de Grep avant de lire quoi que ce soit.
- **Honnêteté** : chaque ticket découle d'un besoin du fichier d'entrée ; toute affirmation s'appuie sur un fichier lu (cadrage, chiffrage, code), cité. Une règle métier, une valeur ou un comportement absent des entrées n'est jamais inventé : il devient un point à clarifier ou « non déterminé ». Tu ne réestimes rien et ne proposes aucune spécification technique détaillée (schéma de base, contrat d'API, maquette).
- **Données personnelles** : aucune adresse e-mail, aucun numéro de téléphone, aucun identifiant ni mot de passe dans le livrable, même dans une citation (coupe ou remplace par « […] ») ; les personnes sont désignées par leur rôle, jamais par leur nom.
- **Désignation des fichiers** : dans tout le livrable, un fichier d'entrée est désigné par son nom de fichier seul (`cadrage-besoin.md`, `chiffrage.md`, `besoin-client.txt`), jamais avec son répertoire ni par un chemin absolu. Seuls les fichiers du code, dans « Fichiers concernés » et « Contexte », sont cités par leur chemin relatif à la racine du projet.
- **Langue** : le livrable est rédigé en français.
## Étape 1 : déterminer l'entrée

1. Analyse les arguments (un chemin contenant des espaces est entre guillemets).
   - **Aucun argument** : l'entrée est `docs/wf/cadrage-besoin.md`. Vérifie avec Glob qu'il existe. S'il n'existe pas, n'écris rien et réponds qu'il faut d'abord lancer `/wf-cadrage-besoin` pour cadrer le besoin, ou fournir un fichier de besoin : `/wf-specs-tickets <fichier>`, lancée à la racine du projet.
   - **Un argument au nom de fichier d'environnement** (`.env*`) : écarte-le sans le chercher ni l'ouvrir ; réponds qu'il n'est jamais lu (« fichier d'environnement, jamais lu ») et n'écris rien.
   - **Un argument qui ressemble à un chemin** (il contient `/` ou se termine par une extension de fichier, sans former une phrase) : lis-le avec Read ; c'est l'entrée, à la place du cadrage. Si Read échoue parce que le fichier n'existe pas, réponds que le fichier est introuvable, en le nommant, et n'écris rien.
   - **Sinon** (plusieurs mots formant une phrase, une demande rédigée…), c'est un texte saisi : réponds que le texte saisi dans la commande n'est pas accepté comme entrée, que seuls le cadrage par défaut (sans argument) ou un fichier de besoin (`/wf-specs-tickets <fichier>`) le sont, et n'écris rien.
   - **Plusieurs chemins** : un seul fichier de besoin est accepté ; réponds-le en rappelant la syntaxe, et n'écris rien.
2. Vérifie avec Glob si `docs/wf/specs-tickets.md` existe. S'il existe, lis-le avec Read : c'est une relance (étape 6).
3. Vérifie avec Glob si `docs/wf/chiffrage.md` existe (étape 3).

## Étape 2 : lire les besoins

**Cadrage** (`docs/wf/cadrage-besoin.md`, livrable de `wf-cadrage-besoin`) : lis-le avec Read et exploite :

- la section « Besoins fonctionnels » : chaque ligne `- Bnn : <libellé>. Priorité : … Source : …` est un besoin, dont tu reprends l'identifiant `Bnn` tel quel ;
- la section « Questions au client » : chaque ligne `- Qnn (Bxx, Byy) : <question>` (les besoins entre parenthèses sont facultatifs), suivie d'une ligne `Réponse :`. Une question est **ouverte** si rien ne suit `Réponse :` ; sinon sa réponse est un fait, à citer « réponse à Qnn » ;
- pour le contexte des tickets : « Utilisateurs et rôles » (rôles des récits), « Contraintes » (dont les ordres de livraison imposés), « Hors périmètre ».

**Fichier de besoin passé en argument** : lis-le avec Read. S'il utilise des identifiants `Bnn` (et `Qnn`), reprends-les tels quels. Sinon, attribue toi-même `B01`, `B02`… aux besoins, dans l'ordre où ils apparaissent, liste-les dans « Synthèse » avec leur source (nom de fichier seul et titre de section), et recommande dans « Points non déterminés » de passer d'abord par `/wf-cadrage-besoin`.

Un besoin est une chose que les utilisateurs doivent pouvoir faire. Si le fichier d'entrée n'en contient aucun, ou si Read n'en tire aucun texte, n'écris rien : réponds que le fichier ne contient aucun besoin identifiable, en le nommant, et qu'aucun livrable n'a été écrit. Ne va pas chercher de besoins dans d'autres fichiers du projet.

## Étape 3 : lire le chiffrage, s'il existe

Si `docs/wf/chiffrage.md` existe (livrable de `wf-chiffrage`), lis-le avec Read et relève, dans les tableaux des sections « Détail par lot » et « Activités transverses », chaque tâche : identifiant `Cnn` (`C01`, `C02`…), libellé, besoins couverts `Bnn`, estimation basse et estimation haute en jours.

- Tu ne réestimes jamais : tu cites les tâches et reprends leurs estimations telles quelles.

## Étape 4 : lire le code, s'il existe

Cherche le code source du projet avec Glob (ex. `**/*.{ts,tsx,js,jsx,mjs,vue,svelte,dart,py,rb,php,java,kt,swift,go,rs,cs}`), en ignorant `node_modules/`, `build/`, `dist/`, `.dart_tool/`, `docs/` et tout fichier `.env*`.

- **Aucun fichier source** : le projet est sans code ; la rubrique « Fichiers concernés » de chaque ticket indique exactement « non applicable (projet sans code) ». Le livrable est produit normalement.
- **Code présent** : pour chaque ticket, repère avec Glob et Grep (mode `files_with_matches`) les fichiers que sa réalisation modifiera, lis ceux qui sont utiles avec Read, et cite-les par leur chemin relatif. Ne cite qu'un chemin que Glob a effectivement trouvé ; un fichier qui n'existe pas encore est cité suivi de « (à créer) ». Si tu ne peux pas déterminer les fichiers d'un ticket, écris « non déterminé ».

## Étape 5 : construire les tickets

**Découpage**

- Un ticket est un incrément livrable et testable. Il couvre un ou plusieurs besoins `Bnn` ; un besoin trop gros est découpé en plusieurs tickets.
- Chaque besoin de l'entrée est couvert par au moins un ticket, ou figure dans « Besoins non couverts » avec sa raison (ex. « trop imprécis pour écrire un critère vérifiable en l'état, voir Qnn », « non chiffrable en l'état selon chiffrage.md »). Un élément du « Hors périmètre » du cadrage n'est l'objet d'aucun ticket.
- **Avec chiffrage** : la rubrique « Estimation » de chaque ticket cite les tâches `Cnn` qu'il couvre, c'est-à-dire des tâches dont un besoin couvert figure dans sa rubrique « Besoins couverts », avec leur estimation telle que dans le chiffrage : `C04 (0,5 à 1 j), C07 (3 à 4 j) ; total 3,5 à 5 j`. Le total, facultatif, est la somme exacte des estimations citées. Chaque tâche de « Détail par lot » est citée par un ticket (de préférence un seul), sauf si son besoin est dans « Besoins non couverts ». Une tâche de « Activités transverses » n'est citée que par un ticket qui la réalise directement (elle produit elle-même un résultat livrable) ; celles qui accompagnent toute la réalisation sans rien livrer en propre ne font pas l'objet d'un ticket et sont mentionnées dans « Synthèse ».
- **Taille maximale** : pour tout ticket qui cite au moins deux tâches `Cnn`, la somme de leurs estimations hautes est d'au plus 5 jours. Au-delà, découpe le ticket (ex. une tâche par ticket). Vérifie cette somme pour chaque ticket avant d'écrire. Un ticket qui ne cite qu'une seule tâche n'est pas concerné.
- **Sans chiffrage** : la rubrique « Estimation » indique exactement « non estimé », sans aucune estimation (ni jours, ni points, ni taille).

**Rubriques de chaque ticket**, toutes présentes, dans cet ordre :

1. **Récit utilisateur** : une phrase « En tant que <rôle>, je veux <action>, afin de <bénéfice>. », le rôle étant tiré de l'entrée (« Utilisateurs et rôles » du cadrage) ; s'il n'y figure pas : « En tant qu'utilisateur (rôle non déterminé) ».
2. **Contexte** : ce qui justifie le ticket, avec ses sources (`cadrage-besoin.md, Bnn`, `réponse à Qnn`, chemins du code).
3. **Critères d'acceptation** : au moins un critère. Chacun est numéroté `CA1`, `CA2`… en repartant de 1 dans chaque ticket, et rédigé « Étant donné <situation>, quand <action>, alors <résultat observable> ». Ils ne décrivent que ce que l'entrée établit (besoin, réponse, contrainte). Après la liste, ajoute la ligne « Dernier critère attribué : CAn. » (le plus grand numéro jamais attribué dans ce ticket).
4. **Hors périmètre** : ce que le ticket ne fait pas (éléments exclus par le cadrage, parties couvertes par un autre ticket : « couvert par Tnn ») ; sinon « Aucun. ».
5. **Dépendances** : les tickets `Tnn` qui doivent être réalisés avant celui-ci, chacun avec sa raison ; sinon « aucune ».
6. **Besoins couverts** : les identifiants `Bnn` couverts, tous existants dans l'entrée (au moins un).
7. **Estimation** : voir « Découpage ».
8. **Fichiers concernés** : voir l'étape 4.
9. **Points à clarifier** : chaque question ouverte `Qnn` de l'entrée qui porte sur un des besoins couverts par le ticket (ses besoins sont entre parenthèses dans « Questions au client »), avec son objet : `Qnn : <objet>`. Une question dont la réponse est remplie n'y figure jamais (c'est un fait, cité dans « Contexte » ou les critères). S'il n'y a aucune question ouverte pour ces besoins, écris exactement « aucun ». Une question ouverte qui ne porte sur aucun besoin n'est citée par aucun ticket : elle figure dans « Points non déterminés ».

**Termes vagues** : un critère d'acceptation ne contient jamais « rapide », « simple », « intuitif », « facile », « convivial » ou « performant » (ni leurs accords et adverbes) sans une valeur mesurable associée (durée, nombre, seuil) tirée de l'entrée. Si l'entrée n'en donne aucune (question ouverte), écris le critère sans ce terme, sur un résultat observable, et laisse la question dans « Points à clarifier ». N'invente jamais de seuil.

**Dépendances et ordre de réalisation**

- Une dépendance vient soit d'un ordre imposé par l'entrée (contrainte, réponse), cité dans la raison, soit d'un prérequis évident entre tickets (un ticket utilise ce qu'un autre crée). N'en invente aucune autre.
- Reprends tels quels les ordres imposés par l'entrée : ne fusionne ni ne redécoupe des tickets pour faire disparaître un cycle.
- **Sans cycle** : « Ordre de réalisation » liste tous les tickets une seule fois, numérotés, chacun après ceux dont il dépend ; entre tickets indépendants, les besoins les plus prioritaires d'abord, puis par identifiant.
- **Cycle** (des tickets qui dépendent les uns des autres, directement ou non) : « Ordre de réalisation » ne propose aucun ordre ; il indique « Aucun ordre proposé : cycle de dépendances entre <Tnn> et <Tnn>, voir « Points non déterminés ». » « Points non déterminés » décrit le cycle (`Tnn → Tmm → Tnn`), en citant les tickets concernés et la source de chaque dépendance, et la question qui permettrait de le lever s'il y en a une.
- Dans les deux cas, « Ordre de réalisation » contient le schéma Mermaid des dépendances (modèle plus bas) : un nœud par ticket, une flèche `Tavant --> Taprès` par dépendance déclarée dans les tickets, ni plus ni moins.

## Étape 6 : relance sur un livrable existant

Le livrable précédent est relu, puis entièrement réécrit avec Write (jamais un second livrable à la suite, ni un autre fichier) :

- **Tickets** : un ticket dont les besoins couverts n'ont pas changé conserve son identifiant `Tnn` ; garde aussi son titre si rien ne justifie de le changer. Un ticket dont les besoins ont en partie changé mais qui porte toujours sur le même sujet garde son identifiant.
- **Critères** : un critère conservé garde son numéro `CAn`. Un nouveau critère dans un ticket existant reçoit le numéro qui suit le plus grand entre la ligne « Dernier critère attribué » du ticket et le plus grand `CAn` présent. Le numéro d'un critère supprimé n'est jamais réattribué, même pour combler un trou (ex. `CA4` supprimé alors que `CA5` existe).
- **Nouveaux tickets** : calcule `Tmax`, le plus grand entre le `Tnn` de la ligne « Derniers identifiants attribués » et le plus grand `Tnn` présent dans le livrable précédent. Les nouveaux tickets reçoivent `Tmax + 1`, `Tmax + 2`…, dans l'ordre d'ajout. Tout identifiant inférieur ou égal à `Tmax` absent du livrable précédent est retiré et n'est jamais réattribué, même s'il comble un trou.
- **Ticket supprimé** (ses besoins ont disparu de l'entrée) : son identifiant est retiré pour toujours ; signale-le dans « Points non déterminés » (« Tnn retiré : Bnn n'est plus dans le cadrage »).
- Avant d'écrire, vérifie chaque identifiant contre ces règles. Mets à jour la date, le commit, les fichiers d'entrée et la ligne « Derniers identifiants attribués ».

## Étape 7 : écrire le livrable

Récupère avec Bash, **avant d'écrire** : la date (`date +%F`) et le commit (`git rev-parse --short HEAD`). Si cette commande échoue (pas un dépôt git, ou dépôt sans commit), le commit est « non déterminé (le projet n'est pas un dépôt git) ». Sinon, lance `git status --porcelain -- . ':(exclude)docs/wf'` : si la sortie n'est pas vide, ajoute « modifications non commitées » après le commit ; si elle est vide, n'écris cette mention nulle part.

Crée `docs/wf/` si besoin (`mkdir -p docs/wf`), puis écris le livrable avec Write, d'un seul tenant, selon ce modèle (les cinq sections dans cet ordre, avec ces noms exacts ; dans chaque ticket, les neuf rubriques dans cet ordre, avec ces noms exacts) :

```markdown
# Tickets : <objet du besoin>

- Outil : wf-specs-tickets
- Date : <AAAA-MM-JJ>
- Commit analysé : <hash court | non déterminé (le projet n'est pas un dépôt git)>[, modifications non commitées]
- Fichiers d'entrée : <cadrage-besoin.md | nom du fichier de besoin>[, chiffrage.md]
- Derniers identifiants attribués : T<nn>

## Synthèse

<2 à 4 phrases : nombre de tickets, besoins couverts, besoins non couverts, ce qui reste à clarifier ; estimation totale reprise du chiffrage ou « non estimé » ; activités transverses non ticketées s'il y en a.>

Recommandation : citez l'identifiant du ticket dans le nom de la branche ou dans le message du commit qui le réalise (ex. `feat/T03-export-pdf`), pour permettre le suivi par `wf-rapport-avancement`. Un critère se cite sous la forme `T03-CA2`. C'est une convention recommandée, pas une obligation.

## Ordre de réalisation

1. T01 : <titre>
2. T02 : <titre>

<schéma Mermaid des dépendances, voir ci-dessous>

## Tickets

### T01 : <titre>

#### Récit utilisateur

En tant que <rôle>, je veux <action>, afin de <bénéfice>.

#### Contexte

<faits qui justifient le ticket> (<source>).

#### Critères d'acceptation

- CA1 : Étant donné <situation initiale>, quand <action>, alors <résultat observable>.
- CA2 : Étant donné <situation initiale>, quand <action>, alors <résultat observable>.

Dernier critère attribué : CA2.

#### Hors périmètre

<élément exclu> | Aucun.

#### Dépendances

<T00 : raison> | aucune

#### Besoins couverts

B01[, B02]

#### Estimation

<C04 (0,5 à 1 j)[, C07 (3 à 4 j) ; total 3,5 à 5 j]> | non estimé

#### Fichiers concernés

- `<chemin existant>` : <rôle dans le ticket>
- `<chemin>` (à créer) : <rôle>

ou : non applicable (projet sans code)

#### Points à clarifier

- Qnn : <objet de la question ouverte>

ou : aucun

## Besoins non couverts

- Bnn : <raison>.

## Points non déterminés

- <information non établie, cycle de dépendances, ticket retiré, question ouverte sans besoin (Qnn)> : non déterminé.
```

Schéma Mermaid, à placer dans « Ordre de réalisation » (une flèche va du ticket à réaliser d'abord vers celui qui en dépend ; un ticket sans dépendance figure seul sur sa ligne) :

```mermaid
graph LR
  T01 --> T02
  T03
```

- **Section vide** : les cinq sections sont toujours présentes. Une section sans élément contient la seule ligne « Aucun élément. ».
- Identifiants : `T01`, `T02`…, sur deux chiffres, uniques. « Derniers identifiants attribués » porte le plus grand `Tnn` jamais attribué, y compris retiré depuis.
- Avant d'écrire, relis chaque critère d'acceptation à la recherche des termes vagues interdits, et chaque chemin de « Fichiers concernés » : trouvé par Glob, ou marqué « (à créer) ».

## Message final

Court, en français : chemin du livrable écrit ou mis à jour, nombre de tickets, besoins non couverts, cycle éventuel, fichiers d'entrée utilisés. Rappelle qu'aucun ticket n'a été créé dans un outil de suivi. Aucune question à l'utilisateur. Si rien n'a été écrit, dis-le explicitement, avec la raison.
