---
name: wf-cadrage-besoin
description: Tire d'un ou plusieurs fichiers de demande client (brief, cahier des charges, notes d'échange, e-mail de réponse ; Markdown, texte ou PDF) un document de cadrage structuré dans docs/wf/cadrage-besoin.md - besoins priorisés et sourcés, contraintes, hors périmètre, hypothèses, questions au client à remplir. À utiliser pour cadrer un besoin avant de chiffrer, ou pour mettre à jour un cadrage existant avec les réponses du client.
argument-hint: <fichier> [<fichier>…]
---

# wf-cadrage-besoin

Tu produis le cadrage d'un besoin client à partir de fichiers sources, dans le livrable `docs/wf/cadrage-besoin.md` du projet courant. Ce livrable est lu par `wf-chiffrage` et `wf-specs-tickets` : son chemin, les noms de ses sections et les identifiants `Bnn` et `Qnn` sont un contrat, à respecter à la lettre.

Arguments de la commande (vide si aucun) : $ARGUMENTS

## Règles permanentes

- **Aucune question pendant l'exécution** : tout ce qui est à clarifier va dans le livrable. Ne demande jamais de confirmation.
- **Écriture** : le seul fichier que tu écris est `docs/wf/cadrage-besoin.md` (tu peux créer le dossier `docs/wf/`). Aucun fichier temporaire, aucune modification des sources, ni de quoi que ce soit d'autre dans le projet. Pas de branche, pas de commit.
- **Sources** : seuls les fichiers passés en argument (et, à la relance, ceux listés dans l'en-tête du livrable) sont lus. Le code et les autres fichiers du projet ne sont ni lus, ni listés, ni cités : le livrable n'affirme rien sur l'existant (stack, bibliothèques, fonctionnalités déjà faites).
- **Fichiers d'environnement** : un fichier dont le nom commence par `.env` (`.env`, `.env.local`, `.env.md`…), qu'il vienne des arguments ou de l'en-tête, est écarté sans être ouvert, quelle que soit son extension : ni Read, ni commande qui le lise. Seul `.env.example` pourrait être lu, mais ce n'est pas une source de demande : il est écarté comme les autres. Raison à indiquer : « fichier d'environnement, jamais lu ».
- **Honnêteté** : toute affirmation s'appuie sur une source citée. Une information absente de toutes les sources n'est jamais affirmée ni devinée : elle est « non déterminé » ou fait l'objet d'une question. Ne propose ni solution technique, ni architecture, ni chiffrage.
- **Données personnelles** : aucune adresse e-mail, aucun numéro de téléphone, aucun identifiant ni mot de passe dans le livrable, même dans une citation (coupe ou remplace par « […] »). Par précaution, ne reprends aucun nom de personne figurant dans les sources : désigne chacune par son rôle tel que la source le donne.
- **Langue** : le livrable est rédigé en français, quelle que soit la langue des sources. Les citations restent dans leur langue d'origine, entre « », sans traduction à leur place.
- **Désignation des sources** : dans la ligne « Sources lues » de l'en-tête, chaque source garde son chemin tel que donné (relatif au projet, ou absolu si elle est hors du projet). Partout ailleurs dans le livrable, une source est désignée par son nom de fichier seul (`brief.md`), sans répertoire.

## Étape 1 : déterminer les sources

1. Vérifie avec Bash (`test -f`) si `docs/wf/cadrage-besoin.md` existe. S'il existe, lis-le avec Read : c'est une relance (étape 5).
2. Analyse les arguments (un chemin contenant des espaces est entre guillemets). Un argument au nom de fichier d'environnement (`.env*`) est écarté d'emblée, sans test ni commande qui le cite ; il compte comme un chemin. Pour les autres :
   - **Aucun argument et aucun livrable** : indique la syntaxe attendue et arrête-toi sans rien écrire :
     `/wf-cadrage-besoin <fichier> [<fichier>…]` (brief, cahier des charges, notes ; Markdown `.md`, texte `.txt` ou PDF à texte extractible), lancée à la racine du projet.
   - **Au moins un argument est un fichier existant** (`test -f`) : tous les arguments sont des chemins de fichiers ; ceux qui n'existent pas sont « fichier introuvable ».
   - **Aucun argument n'est un fichier existant** : si aucun ne ressemble à un chemin (ni `/`, ni extension de fichier), c'est un texte saisi : réponds que seules des sources sous forme de fichier (Markdown, texte ou PDF) sont acceptées, que le texte saisi n'est pas pris comme source, rappelle la syntaxe ci-dessus, et arrête-toi sans rien écrire. Sinon, chaque argument est un chemin, introuvable.
3. Liste des sources à lire : les arguments, plus, en cas de relance, les sources de la ligne « Sources lues » de l'en-tête (y compris celles marquées « (introuvable) »). Une source de l'en-tête est cherchée à son chemin enregistré uniquement, sans aucune recherche ailleurs dans le projet : si ce fichier n'existe pas, elle est introuvable. Un argument qui porte le même nom de fichier qu'une source de l'en-tête la remplace, avec son nouveau chemin.
4. Écarte, en notant la raison pour chacune :
   - un nom de fichier d'environnement (`.env*`, voir les règles permanentes), sans l'ouvrir ;
   - un chemin qui n'existe pas (« fichier introuvable ») ;
   - une extension autre que `.md`, `.markdown`, `.txt` ou `.pdf` (ex. `.docx`, `.eml`) : « format non pris en charge, à convertir en Markdown, texte ou PDF ». N'ouvre pas ce fichier et n'en exploite rien ;
   - un PDF sans texte extractible (étape 2) ;
   - un PDF illisible parce que poppler n'est pas installé (`pdfinfo` ou `pdftotext` introuvable) : indique d'installer poppler (`brew install poppler` ou `poppler-utils`), sans rien déduire du nom du fichier.
5. Si aucune source n'est lisible, n'écris rien : indique dans ton message chaque fichier en cause, nommé, avec sa raison, et qu'aucun livrable n'a été écrit faute de source lisible.

## Étape 2 : lire les sources

- Markdown et texte : Read. Repère pour chaque passage le titre de section Markdown (`#`, `##`…) sous lequel il se trouve.
- PDF : jamais avec Read (il montrerait les pages en images). Avec Bash uniquement :
  1. `pdfinfo "<fichier>"` : nombre de pages (ligne `Pages:`) ;
  2. pour chaque page N, `pdftotext -f N -l N "<fichier>" -` : texte de la page N. Une page est « sans texte » si cette sortie est vide ou ne contient que des espaces.
  - Si toutes les pages sont sans texte, le PDF n'a pas de texte extractible (document scanné, par exemple) : écarte-le, sans chercher à voir ni à transcrire ce que montrent ses pages.
  - Sinon, exploite le texte des pages qui en ont, et cite chaque passage avec le numéro de la page dont pdftotext l'a extrait. Les pages sans texte sont signalées dans « Points non déterminés ».
- Une source se cite ainsi : `nom.md, « Titre de section »` ; `nom.pdf, page N` ; `nom.txt` (ou `nom.md` sans titre de section s'il n'en a pas) ; `réponse saisie à la question Qnn` pour une réponse au client.

## Étape 3 : analyser

- **Besoins fonctionnels** : ce que les utilisateurs doivent pouvoir faire. Fusionne un même besoin cité par plusieurs sources (toutes citées).
- **Priorité** : uniquement sur l'échelle « indispensable », « important », « souhaitable », et seulement si la source l'exprime pour ce besoin. Toute tournure qui exprime explicitement un niveau de priorité, dans la langue de la source, est ramenée au niveau correspondant de l'échelle. Sinon : « non précisée ». Ne déduis jamais une priorité de l'ordre, de l'insistance ou du bon sens.
- **Qualificatif non quantifié** sur la performance, le volume, le délai ou l'ergonomie (« rapide », « beaucoup de », « simple à utiliser », « au plus vite »…) : une question qui cite la phrase source entre « » et demande un critère mesurable (nombre par mois, temps de réponse, critère vérifiable…).
- **Contradiction entre sources** : une question qui cite les deux sources et leurs versions ; aucune des deux n'est retenue dans « Besoins fonctionnels » ou « Contraintes » (tout au plus « non déterminé, voir Qnn »). Cela vaut aussi pour ce qui découle d'une seule des deux versions (ex. une fonction propre à l'une seule des options en débat) : il n'apparaît que dans la question, jamais comme besoin.
- **Plateformes cibles** (web, iOS, Android) : si les sources ne les précisent pas, pose la question et n'en présente aucune comme acquise, nulle part.
- **Exclusion explicite** : tout élément qu'une source exclut explicitement du projet, quelle que soit la tournure ou la langue, va dans « Hors périmètre » avec sa source, jamais dans « Besoins fonctionnels ».
- **Informations utiles au chiffrage** : plateformes cibles, volumétrie, nombre d'utilisateurs, hébergement, date de mise en production, budget, reprise de données existantes, intégrations avec d'autres outils. Pour chacune absente ou imprécise dans les sources, pose une question ; n'affirme rien à leur sujet.
- **Hypothèses** : seulement ce que tu dois supposer pour comprendre le besoin, formulé « Hypothèse à valider : … (voir Qnn) », chacune liée à une question existante qui la lèverait.

## Étape 4 : écrire le livrable

Récupère avec Bash, **avant d'écrire** : la date (`date +%F`), le commit (`git rev-parse --short HEAD`) et l'état du répertoire (`git status --porcelain`). Hors dépôt git, le commit est « non déterminé (le projet n'est pas un dépôt git) ». Si `git status --porcelain` n'est pas vide, ajoute « modifications non commitées » après le commit.

Crée `docs/wf/` si besoin (`mkdir -p docs/wf`), puis écris le livrable avec Write, d'un seul tenant, selon ce modèle (les neuf sections, dans cet ordre, avec ces noms exacts) :

```markdown
# Cadrage du besoin : <objet de la demande>

- Outil : wf-cadrage-besoin
- Date : <AAAA-MM-JJ>
- Commit analysé : <hash court | non déterminé (le projet n'est pas un dépôt git)>[, modifications non commitées]
- Sources lues : <chemin tel que donné>, <chemin tel que donné>[ (introuvable)]
- Derniers identifiants attribués : B<nn>, Q<nn>

## Synthèse

<3 à 5 phrases : qui demande quoi, pour qui, et les principaux points ouverts (Qnn).>

## Contexte et objectifs

- <fait> (<source>).

## Utilisateurs et rôles

- <Rôle> : <ce qu'il fait ou attend> (<source>).

## Besoins fonctionnels

- B01 : <libellé>. Priorité : <indispensable | important | souhaitable | non précisée>. Source : <source>[ ; <source>].

## Contraintes

- <contrainte> (<source>).

## Hors périmètre

- <élément exclu> (<source>).

## Hypothèses

- Hypothèse à valider : <supposition> (voir Q01).

## Questions au client

- Q01 (B01) : <« citation » (source) si la question part d'une phrase> : <question> ?
  Réponse :
- Q02 : <question sans besoin concerné> ?
  Réponse :

## Points non déterminés

- <information non établie, source écartée ou introuvable avec sa raison> : non déterminé.
```

- **Section vide** : les neuf sections sont toujours présentes. Une section sans aucun élément contient la seule ligne « Aucun élément. », jamais un contenu déduit pour la remplir.
- Identifiants : `B01`, `B02`… et `Q01`, `Q02`…, uniques, sur deux chiffres. Une question qui porte sur un ou plusieurs besoins les indique entre parenthèses (`Q04 (B01, B05)`).
- « Derniers identifiants attribués » : les plus grands `Bnn` et `Qnn` jamais attribués, y compris s'ils ont été retirés depuis.
- À la première exécution, chaque champ « Réponse : » reste vide : rien après les deux-points.
- « Points non déterminés » liste aussi chaque source écartée ou introuvable, nommée par son nom de fichier, avec sa raison.

## Étape 5 : relance sur un livrable existant

Le livrable précédent est relu, puis entièrement réécrit avec Write en conservant ce qui reste vrai :

- **Réponses saisies** : tout champ « Réponse : » non vide est recopié **mot pour mot**, jamais reformulé, complété ni remplacé.
- **Nouvelle source qui répond à une question** dont le champ est vide : remplis le champ avec la réponse, suivie de sa source (`Réponse : <réponse> (source : reponse.md)`). Une source qui ne donne pas la réponse ne remplit pas le champ : il reste vide. Ne remplis jamais un champ par déduction.
- **Intégration des réponses** (saisies à la main ou remplies ainsi) : mets à jour les sections concernées (besoins, contraintes, contexte…) en citant « réponse saisie à la question Qnn » comme source. La réponse prévaut sur les sources pour ce point : la contradiction est levée, et les hypothèses qu'elle tranche disparaissent ou deviennent des faits sourcés par la réponse. La question reste dans « Questions au client » avec sa réponse.
- **Identifiants** : un besoin ou une question déjà présent garde son identifiant. Un nouvel élément reçoit le numéro suivant le plus grand identifiant jamais attribué (ligne « Derniers identifiants attribués », ou à défaut le plus grand présent dans le livrable) : on ne comble jamais un trou, un identifiant retiré n'est jamais réattribué. Avant d'ajouter une question, vérifie qu'aucune question existante ne couvre déjà le point.
- **Sources** : relis toutes les sources (étape 1) et ajoute les nouvelles à « Sources lues ». Une source introuvable n'est jamais retirée de « Sources lues » : elle y reste avec son chemin, marquée « (introuvable) », et est signalée dans « Points non déterminés » à chaque relance (à repasser en argument si elle est retrouvée) ; une source retrouvée perd cette marque. Une source écartée pour une autre raison (format, PDF sans texte, fichier d'environnement) est retirée de « Sources lues » et signalée dans « Points non déterminés ». Les éléments qui ne reposaient que sur une source introuvable ou écartée sont conservés, et tu continues avec les autres sources.
- Mets à jour la date et le commit de l'en-tête.

## Message final

Court, en français : chemin du livrable écrit ou mis à jour, nombre de besoins et de questions ouvertes, et chaque source écartée ou introuvable nommée avec sa raison. Aucune question à l'utilisateur. Si rien n'a été écrit, dis-le explicitement.
