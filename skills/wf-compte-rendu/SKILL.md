---
name: wf-compte-rendu
description: Transforme des notes de réunion brutes ou une transcription (fichier .txt, .md, .vtt, .srt, ou texte collé) en un compte rendu structuré, prêt à diffuser, dans docs/wf/compte-rendu/AAAA-MM-JJ-<objet>.md, avec un index des comptes rendus - participants, points abordés, décisions, actions (responsable, échéance), questions en suspens. À utiliser après une réunion de suivi ou une revue, pour garder la trace des décisions et des actions à côté du code.
argument-hint: [<fichier de notes> | <texte des notes>]
---

# wf-compte-rendu

Tu transformes les notes d'**une** réunion (notes brutes ou transcription) en un compte rendu structuré, écrit dans le dossier `docs/wf/compte-rendu/` du projet courant, et tu tiens à jour l'index `docs/wf/compte-rendu/index.md`. Les noms de fichiers et les noms de sections du compte rendu sont un contrat : la section « Questions en suspens » est lue par `wf-rapport-avancement`. Respecte-les à la lettre.

Arguments de la commande (vide si aucun) : $ARGUMENTS

## Règles permanentes

- **Une seule source** : les notes passées en argument (fichier ou texte collé), ou fournies en réponse à ta question. Le code et les autres fichiers du projet ne sont ni lus, ni listés, ni recherchés (pas de Glob, pas de Grep, pas de `cat`, `grep`, `find`… sur le projet). Seules exceptions : `ls docs/wf/compte-rendu/` et la lecture (Read) des comptes rendus de ce dossier, pour l'index et les doublons. Le compte rendu ne cite aucun chemin de fichier du projet qui ne figure pas dans les notes.
- **Écriture** : les seuls fichiers que tu écris (avec Write) sont le compte rendu `docs/wf/compte-rendu/AAAA-MM-JJ-<objet>.md` et `docs/wf/compte-rendu/index.md` (tu peux créer le dossier avec `mkdir -p docs/wf/compte-rendu`). Le fichier de notes n'est jamais modifié, déplacé ni copié ; un texte collé n'est enregistré dans aucun fichier intermédiaire. Aucun fichier temporaire, aucune modification hors de `docs/wf/`, pas de branche, pas de commit. Rien n'est écrit tant que la source, la date et le nom du fichier ne sont pas établis.
- **Questions** : tu ne poses une question que dans trois cas : aucune source (étape 1), date de réunion introuvable (étape 3), compte rendu du même nom tiré d'autres notes (étape 4). Tu poses alors la question, tu n'écris rien et tu termines ton message en attendant la réponse ; à la réponse, tu reprends là où tu t'étais arrêté. Hors de ces trois cas, aucune question ni demande de confirmation.
- **Fichiers d'environnement** : un fichier de notes dont le nom commence par `.env` (`.env`, `.env.local`, `.env.md`…) est refusé sans être ouvert, quelle que soit son extension, y compris `.env.example` : ce n'est pas une source de notes. Raison à indiquer : « fichier d'environnement, jamais lu ».
- **Honnêteté** : chaque participant, décision, action, échéance et question du compte rendu figure dans les notes. Rien n'est ajouté depuis une autre source ni deviné (ni connaissance générale, ni autre fichier). Ce que les notes ne disent pas est « non déterminé ».
- **Données personnelles** : aucune adresse e-mail, aucun numéro de téléphone dans le compte rendu, même dans une citation (coupe ou remplace par « […] »). Les participants sont désignés par leur nom tel qu'écrit dans les notes, suivi de leur rôle si les notes le donnent ; aucun rôle n'est inventé.
- **Secrets** : un mot de passe, un token, une clé d'API ou tout autre secret présent dans les notes n'est jamais recopié, ni en entier, ni en partie, ni masqué ; l'identifiant de connexion qui l'accompagne non plus. « Points non déterminés » signale le retrait (« Un secret (mot de passe) figurait dans les notes : il a été retiré du compte rendu. »), sans le reproduire.
- **Langue** : le compte rendu est rédigé en français, quelle que soit la langue des notes. Les noms propres (personnes, sociétés, produits) et les termes techniques (noms de plateformes, de versions, de composants) sont conservés tels quels. Les citations restent dans leur langue d'origine, entre « ».
- **Désignation de la source** : partout dans le compte rendu, la source est le nom du fichier seul (`notes.md`), sans aucun répertoire, même si les notes sont hors du projet ; jamais un chemin relatif ou absolu. Pour un texte collé : « notes fournies dans la conversation ».

## Étape 1 : déterminer la source

Analyse les arguments, débarrassés des espaces de début et de fin et, s'ils sont entourés de guillemets, de ces guillemets.

1. **Aucun argument** : demande la source et arrête-toi sans rien écrire. Ne cherche pas de notes dans le projet. Message type :
   « Indique le chemin du fichier de notes ou de transcription (`.txt`, `.md`, `.vtt` ou `.srt`), ou colle directement le texte des notes dans ta réponse. »
   À la réponse : un chemin est traité comme un argument (points 2 et 3), un texte comme des notes collées (point 4).
2. **L'argument est un fichier existant** (sauf nom en `.env*`, écarté sans test) : c'est un fichier de notes. Teste-le avec la commande « Vérifier un fichier » ci-dessous. Sinon, si l'argument ressemble à un chemin (une seule ligne, sans espace hors guillemets, et contenant un `/` ou se terminant par une extension comme `.md`) : « fichier introuvable » (étape 1 bis).
3. **Chemin suivi d'une précision** : si l'argument ne tient pas en un seul chemin mais que sa première ligne commence par un chemin (premier mot, ou texte entre guillemets, qui contient un `/` ou se termine par une extension) suivi d'autre texte, ce chemin est traité comme au point 2, et le texte qui suit est une **réponse anticipée** aux questions des étapes 3 et 4 (date de la réunion ; « relance » ou « nouvelle réunion »). Applique-la au lieu de poser la question correspondante. Ce n'est pas une source : rien n'en est repris dans le compte rendu, hors la date de la réunion qu'elle donne.
4. **Sinon**, l'argument est le texte des notes, collé dans la commande : c'est la source, désignée « notes fournies dans la conversation ». Un texte collé vide revient au point 1.

### Étape 1 bis : fichier refusé

Pour un fichier de notes, dans cet ordre :

- nom commençant par `.env` : refusé, « fichier d'environnement, jamais lu » ;
- fichier inexistant : « fichier introuvable » ;
- extension (casse ignorée) autre que `.txt`, `.md`, `.vtt` ou `.srt` (ex. `.docx`, `.pdf`) : « format non pris en charge ; formats acceptés : `.txt`, `.md`, `.vtt`, `.srt` ». N'ouvre pas ce fichier et n'en exploite rien, pas même son nom ;
- fichier vide ou ne contenant que des espaces (la commande ci-dessous affiche `vide`) : « fichier de notes vide ».

**Vérifier un fichier.** Le chemin vient de l'utilisateur : ne l'insère jamais dans une commande entre guillemets doubles, ni sans guillemets (une substitution `$(…)` ou un accent grave s'exécuterait). Passe-le par l'entrée standard, dans un heredoc dont le délimiteur est entre apostrophes, en remplaçant seulement la ligne du milieu par le chemin tel quel (une seule ligne) :

```bash
IFS= read -r wf_path <<'WF_CHEMIN'
<chemin du fichier de notes>
WF_CHEMIN
if [ ! -f "$wf_path" ]; then echo introuvable; elif grep -q '[^[:space:]]' -- "$wf_path"; then echo present; else echo vide; fi
```

Dans chacun de ces cas, n'écris rien, et ne te rabats sur aucun autre fichier du projet : indique le fichier en cause, nommé, sa raison, et qu'aucun compte rendu n'a été écrit.

## Étape 2 : lire les notes

Lis le fichier de notes avec Read, et rien d'autre. Formats :

- `.txt`, `.md` : notes brutes ou transcription en texte ; une transcription peut être horodatée avec tours de parole (`[00:12:34] Nom : …`).
- `.vtt` (WebVTT) : ignore l'en-tête `WEBVTT`, les lignes de temps (`00:01:02.000 --> 00:01:09.000`) et les identifiants de repère ; l'orateur est dans la balise `<v Nom>`.
- `.srt` : ignore les numéros de séquence et les lignes de temps (`00:01:02,000 --> 00:01:09,000`) ; l'orateur, s'il est donné, est en début de réplique (`Nom : …`).

## Étape 3 : date et objet de la réunion

**Date de la réunion**, dans cet ordre :

1. une date de réunion écrite dans les notes (titre, ligne « Date : », en-tête), quel que soit son format (« 3 mars 2025 », « 03/03/2025 », « March 3, 2025 »…), convertie au format `AAAA-MM-JJ`. Une échéance d'action n'est pas une date de réunion. Une date sans année n'est retenue que si le nom du fichier donne la même date avec l'année ;
2. sinon, une date au format `AAAA-MM-JJ` dans le nom du fichier de notes ;
3. sinon, la date donnée par une réponse anticipée (étape 1, point 3) ou par ta réponse à la question ci-dessous ;
4. sinon, demande la date de la réunion et arrête-toi sans rien écrire : « Les notes ne donnent pas la date de la réunion. Quelle est-elle (AAAA-MM-JJ) ? ». N'utilise jamais la date du jour sans l'avoir demandée, et ne la propose pas d'office ; ne déduis pas la date d'une échéance ou d'un jour de la semaine.

Si les notes et le nom du fichier donnent deux dates différentes, retiens celle des notes et signale l'écart dans « Points non déterminés ».

**Objet de la réunion**, tel qu'écrit dans les notes, sans reformulation, sans développer d'abréviation et sans traduction :

1. la valeur d'une ligne « Objet : » (ou son équivalent dans la langue des notes : « Subject: », « Topic: ») ;
2. sinon, le titre des notes : un titre Markdown (`# …`), ou la première ligne non vide si elle est courte (10 mots au plus) et n'est ni un élément de liste, ni une ligne de temps, ni un tour de parole, ni `WEBVTT`, ni un numéro. Retire-en la date et les séparateurs qui l'entourent (`—`, `-`, `:`, `|`, `,`) ;
3. sinon, le nom du fichier de notes sans son extension, sans la date `AAAA-MM-JJ` et sans les séparateurs qui l'entourent ;
4. pour des notes collées sans objet ni titre : « Réunion ».

**Nom du fichier** : `AAAA-MM-JJ-<objet>.md`, où `<objet>` est l'objet en minuscules, sans accents, mots séparés par des tirets, au plus 5 mots (les 5 premiers). Calcule-le avec cette commande, sans l'adapter : l'objet vient des notes, il est passé par l'entrée standard dans un heredoc à délimiteur entre apostrophes (aucune substitution possible), en remplaçant seulement la ligne du milieu par l'objet (une seule ligne) ; ne l'insère jamais dans la commande elle-même.

```bash
python3 -c 'import re, sys, unicodedata; s = sys.stdin.read().strip().replace("œ", "oe").replace("Œ", "OE").replace("æ", "ae").replace("Æ", "AE"); s = unicodedata.normalize("NFKD", s).encode("ascii", "ignore").decode().lower(); print("-".join(re.findall(r"[a-z0-9]+", s)[:5]))' <<'WF_OBJET'
<objet>
WF_OBJET
```

Exemple : réunion du 2026-03-02, objet « Revue de lot – Écrans » : `2026-03-02-revue-de-lot-ecrans.md`.

## Étape 4 : compte rendu existant

Liste le dossier avec `ls docs/wf/compte-rendu/` (absent : aucun compte rendu, passe à l'étape 5). Soit `N` le nom calculé, et `N-2`, `N-3`… ses variantes suffixées (`AAAA-MM-JJ-<objet>-2.md`…).

- **Aucun de ces fichiers n'existe** : le compte rendu sera `N`.
- **L'un d'eux a la même source** : lis son en-tête (Read) ; si sa ligne « Source des notes » donne le même nom de fichier que les notes actuelles, c'est une relance sur les mêmes notes, éventuellement complétées : ce fichier est mis à jour (étape 5), sans question et sans créer de nouveau fichier.
- **Sinon** (autre source, ou notes fournies dans la conversation d'un côté ou de l'autre) : si une réponse anticipée (étape 1, point 3) dit « relance » ou « nouvelle réunion », applique-la directement ; sinon, demande, sans rien écrire, s'il s'agit d'une relance ou d'une nouvelle réunion, en nommant le compte rendu existant et sa source. Message type :
  « Un compte rendu `<N>` existe déjà pour cette date et cet objet (source : <source>). S'agit-il d'une relance de cette réunion (le compte rendu existant sera mis à jour) ou d'une nouvelle réunion (un nouveau compte rendu `<AAAA-MM-JJ-objet>-2.md` sera créé, l'existant ne sera pas modifié) ? »
  - Relance : le compte rendu existant est mis à jour.
  - Nouvelle réunion : le compte rendu prend le premier suffixe libre, `-2` d'abord (`…-2.md`), puis `-3`… ; les comptes rendus existants ne sont pas modifiés.

## Étape 5 : rédiger

- **Participants** : les personnes listées comme présentes, ou qui prennent la parole dans une transcription ; chacune par son nom tel qu'écrit, suivi de son rôle s'il est donné (« Nom, rôle »). Aucune coordonnée. Une personne seulement mentionnée (absente, à contacter) n'est pas un participant.
- **Points abordés** : les sujets traités, regroupés par sujet, en phrases de synthèse. Pour une transcription, les répliques sur un même sujet sont fusionnées : aucun horodatage, aucun verbatim ligne à ligne, pas une ligne par tour de parole.
- **Décisions** : uniquement ce qui a fait l'objet d'un accord explicite dans les notes (formulation d'accord explicite, en toute langue : « adopté », « accord de tous », « approved »…). Une proposition, une idée, une piste ou un point « à valider » sans accord explicite n'est jamais une décision : il va dans « Questions en suspens ».
- **Actions** : une ligne par action. Le responsable est la personne que les notes désignent explicitement (nom en tête de l'action, ou orateur qui s'engage à la première personne dans une transcription) ; l'échéance est celle que les notes donnent, recopiée telle qu'écrite (« pour le 05/06 », « d'ici la fin du mois »). Quand les notes ne donnent pas le responsable ou l'échéance, la cellule contient exactement « non déterminé » : n'en déduis jamais (ni du sujet, ni du rôle, ni d'une autre action).
- **Questions en suspens** : les questions restées sans réponse, les propositions sans accord explicite, les points reportés ou à valider. Chaque entrée est une phrase autonome, compréhensible sans les notes : elle est reprise telle quelle par `wf-rapport-avancement`.
- **Points non déterminés** : tout passage ambigu, cité entre « » (ex. un responsable désigné par un pronom sans antécédent), sans trancher l'ambiguïté ailleurs dans le compte rendu (le responsable reste « non déterminé ») ; le retrait d'un secret ; un écart de dates ; une information attendue absente des notes (aucune liste de participants, par exemple).
- **Section vide** : les sept sections sont toujours présentes ; une section sans élément contient la seule ligne « Aucun élément. ». Le tableau des actions reste présent : sans action, son en-tête est suivi de la ligne « Aucun élément. ».

## Étape 6 : écrire

Récupère avec Bash, **avant d'écrire** : la date de génération (`date +%F`), le commit (`git rev-parse --short HEAD`) et, seulement si cette commande a réussi, l'état du répertoire (`git status --porcelain`). Si `git rev-parse` échoue (pas de dépôt git, ou dépôt sans commit), le commit est « hors git ». Si `git status --porcelain` n'est pas vide, ajoute « , modifications non commitées » après le hash.

Crée le dossier si besoin (`mkdir -p docs/wf/compte-rendu`), puis écris le compte rendu avec Write, d'un seul tenant, selon ce modèle (les sept sections, dans cet ordre, avec ces noms exacts) :

```markdown
# Compte rendu : <objet>

- Outil : wf-compte-rendu
- Date : <AAAA-MM-JJ de génération>
- Commit analysé : <hash court | hors git>[, modifications non commitées]
- Date de la réunion : <AAAA-MM-JJ>
- Source des notes : <nom du fichier seul | notes fournies dans la conversation>

## Objet

<objet de la réunion, en une ou deux phrases tirées des notes.>

## Participants

- <Nom tel qu'écrit>[, <rôle si les notes le donnent>]

## Points abordés

- <sujet> : <synthèse des échanges sur ce sujet.>

## Décisions

- <décision explicite.>

## Actions

| Action | Responsable | Échéance |
|---|---|---|
| <action> | <nom | non déterminé> | <échéance telle qu'écrite | non déterminé> |

## Questions en suspens

- <question, proposition sans accord ou point à valider, formulé de façon autonome.>

## Points non déterminés

- <passage ambigu cité entre « », secret retiré, écart, information absente> : non déterminé.
```

**Relance** (étape 4) : relis le compte rendu existant, puis réécris-le entièrement à partir des notes actuelles, sous le même nom de fichier : ce qui figure toujours dans les notes est conservé, ce qui a été ajouté aux notes est intégré, et la date de génération et le commit de l'en-tête sont mis à jour. L'historique est porté par git.

**Index** : réécris ensuite `docs/wf/compte-rendu/index.md` avec Write. Il liste tous les comptes rendus du dossier (tous les fichiers `AAAA-MM-JJ-*.md`, hors `index.md`), y compris celui que tu viens d'écrire, une seule ligne par fichier, du plus récent au plus ancien (par date de réunion, puis par nom de fichier). Pour chacun, la date et l'objet viennent de son en-tête (« Date de la réunion », titre « # Compte rendu : <objet> », lus avec Read) ou, à défaut, de son nom de fichier ; le lien est relatif, par le nom de fichier seul.

```markdown
# Comptes rendus de réunion

- Outil : wf-compte-rendu
- Date : <AAAA-MM-JJ de génération>
- Commit analysé : <hash court | hors git>[, modifications non commitées]

| Date | Objet | Compte rendu |
|---|---|---|
| <AAAA-MM-JJ> | <objet> | [<fichier>.md](<fichier>.md) |
```

Avant d'écrire, relis le compte rendu contre les règles permanentes : aucune adresse e-mail, aucun numéro de téléphone, aucun secret, aucun horodatage, aucun chemin de fichier, aucun élément absent des notes, aucune proposition dans « Décisions ».

## Message final

Court, en français : chemin du compte rendu écrit ou mis à jour, nombre de décisions, d'actions et de questions en suspens, et, le cas échéant, le retrait d'un secret (sans le citer). Si rien n'a été écrit, dis-le explicitement, avec la raison ou la question posée.
