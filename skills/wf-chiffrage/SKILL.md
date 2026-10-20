---
name: wf-chiffrage
description: Estime la charge d'un besoin cadré, en jours (fourchette basse et haute, par pas de 0,5 jour, sans aucun montant), dans docs/wf/chiffrage.md - tâches identifiées Cnn rattachées aux besoins Bnn, activités transverses justifiées, totaux, hypothèses, exclusions, risques. Lit par défaut docs/wf/cadrage-besoin.md (wf-cadrage-besoin), ou un fichier de besoin passé en argument. À utiliser pour préparer la base d'un devis, ou pour mettre à jour un chiffrage après évolution du cadrage.
argument-hint: "[<fichier de besoin>]"
---

# wf-chiffrage

Tu estimes la charge d'un besoin cadré, pour un usage interne (base du devis du freelance, jamais transmise telle quelle au client), dans le livrable `docs/wf/chiffrage.md` du projet courant. Ce livrable est lu par `wf-specs-tickets` : son chemin, les noms de ses huit sections et les identifiants de tâches `Cnn` sont un contrat, à respecter à la lettre.

Arguments de la commande (vide si aucun) : $ARGUMENTS

## Règles permanentes

- **Aucune question pendant l'exécution** : ce qui est à clarifier va dans le livrable (hypothèses, points non déterminés). Ne demande jamais de confirmation.
- **Écriture** : le seul fichier que tu écris est `docs/wf/chiffrage.md`, avec Write (qui crée `docs/wf/` au besoin). Aucun autre fichier n'est créé, modifié, déplacé ou supprimé : ni le fichier d'entrée, ni `docs/wf/cadrage-besoin.md`, ni `docs/wf/analyse-projet.md`, ni le code, ni aucun fichier temporaire. Pas de branche, pas de commit.
- **Aucune exécution** : tu ne lances ni le projet, ni ses tests, ni son installation. Bash ne sert qu'à ces commandes, et à aucune autre :
  - `date +%F`, `git rev-parse --short HEAD`, `git status --porcelain`, recopiées telles quelles ;
  - pour une entrée PDF validée (étape 1), `pdfinfo -- '<fichier>'` et `pdftotext -f N -l N -- '<fichier>' -`, le chemin toujours entre apostrophes après `--` ;
  - `python3 -c 'print(<somme>)'` pour additionner des estimations, où `<somme>` vérifie `^[0-9.+]+$` : uniquement des chiffres, des points et des signes plus.
  L'existence d'un fichier se vérifie avec Glob (le chemin exact comme motif), jamais avec Bash. Pour lire, utilise Read, Glob et Grep.
- **Argument non fiable** : l'argument est un texte libre. Il n'apparaît dans aucune commande Bash, sauf comme chemin d'une entrée PDF validée, entre apostrophes après `--`. Un argument qui contient, une fois retirée la paire de guillemets qui l'entoure éventuellement, une apostrophe, un guillemet, un accent grave, `$`, `\` ou un retour à la ligne est refusé sans rien exécuter : ni Bash, ni Glob, ni Read sur lui, ni repli sur l'entrée par défaut ; réponds que l'argument contient des caractères non admis dans un chemin de fichier et qu'aucun livrable n'a été écrit.
- **Fichiers d'environnement** : un fichier dont le nom commence par `.env` (`.env`, `.env.local`, `.env.production`…), sauf `.env.example`, n'est jamais ouvert, ni avec Read, ni avec Grep, ni avec Bash. Avec Grep, passe toujours le paramètre `glob`, limité à des extensions de code (ex. `*.{ts,tsx,js,jsx,vue,dart}`), même pour un seul dossier. Ne lis pas non plus les fichiers de secrets ou d'identifiants (`.envrc`, `.npmrc`, `key.properties`, clés, certificats). Aucune valeur de variable d'environnement n'est recopiée dans le livrable.
- **Données personnelles** : aucune adresse e-mail, aucun numéro de téléphone, aucun identifiant ni mot de passe dans le livrable, même dans une citation. Aucun nom de personne : désigne chacune par son rôle.
- **Aucun montant** : le chiffrage est en jours uniquement. Le livrable ne contient aucun montant, aucun symbole ni code monétaire, aucun taux journalier, aucune conversion de jours en argent, et ne mentionne même pas ces notions. Tout montant présent dans l'entrée, quelle que soit la section, est ignoré : il n'est ni recopié ni commenté.
- **Honnêteté** : chaque estimation s'appuie sur un élément de l'entrée ou du code lu, cité. Ce qui n'a pas pu être établi est écrit « non déterminé », jamais deviné. Tu ne crées aucune nouvelle question au client (c'est `wf-cadrage-besoin`) : les questions ouvertes de l'entrée deviennent des hypothèses.
- **Désignation des fichiers** : le fichier d'entrée est toujours désigné par son nom de fichier seul (`cadrage-besoin.md`, ou le nom du fichier passé en argument), jamais par un chemin, relatif ou absolu. Les fichiers du code du projet sont cités par leur chemin relatif à la racine du projet. Aucun chemin absolu dans le livrable.
- **Langue** : le livrable est rédigé en français.

## Étape 1 : déterminer l'entrée

1. Vérifie avec Glob (motif `docs/wf/chiffrage.md`) si un livrable existe déjà. S'il existe, lis-le avec Read : c'est une relance (étape 7).
2. Analyse les arguments. L'argument est tout le texte qui suit la commande ; un chemin qui contient des espaces est entre guillemets. Un texte de plusieurs mots sans guillemets n'est donc pas un chemin. Dans cet ordre :
   - **Aucun argument** : l'entrée est `docs/wf/cadrage-besoin.md` (livrable de `wf-cadrage-besoin`). Si Glob ne le trouve pas, n'écris rien et réponds qu'il faut d'abord lancer `/wf-cadrage-besoin` sur les documents du client, ou fournir un fichier de besoin en argument : `/wf-chiffrage <fichier de besoin>`. Arrête-toi là.
   - **Caractère non admis** : applique la règle « Argument non fiable » ci-dessus. Arrête-toi là.
   - **Texte saisi** : un texte de plusieurs mots sans guillemets, ou un mot sans `/` ni extension de fichier, n'est pas un chemin. Réponds que le texte saisi n'est pas accepté comme entrée, qu'il faut passer le chemin d'un fichier de besoin (`/wf-chiffrage <fichier de besoin>`) ou lancer `/wf-cadrage-besoin` puis `/wf-chiffrage` sans argument, et qu'aucun livrable n'a été écrit. Ne te rabats jamais sur `docs/wf/cadrage-besoin.md` dans ce cas, même s'il existe, et ne chiffre rien.
   - **Fichier d'environnement** : un chemin dont le nom de fichier commence par `.env` est écarté sans l'ouvrir ni le chercher ; réponds que c'est un fichier d'environnement, jamais lu, et qu'aucun livrable n'a été écrit.
   - **Format** : seuls Markdown (`.md`, `.markdown`), texte (`.txt`) et PDF à texte extractible (`.pdf`) sont lus. Pour toute autre extension, n'ouvre pas le fichier, réponds qu'il faut le convertir dans l'un de ces formats, et n'écris rien.
   - **Chemin** : vérifie son existence avec Glob. S'il n'existe pas, réponds « fichier introuvable » en le nommant, et n'écris rien. S'il existe, c'est l'entrée, à la place de `docs/wf/cadrage-besoin.md`.

## Étape 2 : lire l'entrée et identifier les besoins

- Markdown et texte : Read. PDF : jamais avec Read ; avec Bash, `pdfinfo -- '<fichier>'` (nombre de pages) puis `pdftotext -f N -l N -- '<fichier>' -` page par page. Un PDF sans aucun texte extractible n'a aucun besoin identifiable (voir plus bas). Si poppler n'est pas installé, indique d'installer poppler et n'écris rien.
- **Date de l'entrée** : relève la date qui figure dans l'en-tête du fichier d'entrée (ligne « Date : » d'un livrable `wf-*`, ou date indiquée en tête du document). Sans date dans l'en-tête : « date non déterminée ».
- **Entrée au format du cadrage** (`wf-cadrage-besoin`, spec 004) : lis les sections « Besoins fonctionnels » (lignes `- Bnn : <libellé>. Priorité : …. Source : …`), « Contraintes », « Hypothèses » et « Questions au client » (lignes `- Qnn (Bnn, …) : <question>` suivies de `Réponse :`), ainsi que « Hors périmètre ». Reprends les identifiants `Bnn` et `Qnn` tels quels, sans jamais les renuméroter.
- **Entrée sans identifiants `Bnn`** (document de besoin brut) : identifie toi-même les besoins fonctionnels (ce que les utilisateurs doivent pouvoir faire) et attribue-leur `B01`, `B02`… dans l'ordre du document. Chaque besoin garde sa source : nom de fichier seul et section (titre ou numéro de section Markdown) ou page (PDF). Les questions ouvertes n'existent pas dans ce cas : les incertitudes deviennent des hypothèses de l'outil.
- **Aucun besoin identifiable** (document sans fonctionnalité demandée, PDF sans texte, fichier vide) : n'écris rien ; réponds que le fichier ne contient aucun besoin identifiable à chiffrer et qu'aucun livrable n'a été écrit. N'invente aucun besoin, et ne cherche pas de besoin dans d'autres fichiers du projet.
- **Questions `Qnn`** : une question dont le champ « Réponse : » est rempli est un fait, cité par son identifiant (« réponse à Qnn »). Une question dont le champ « Réponse : » est vide et qui influe sur une estimation donne lieu à une hypothèse (étape 5).

## Étape 3 : entrées complémentaires

- **Livrable d'analyse** : si Glob trouve `docs/wf/analyse-projet.md`, lis sa section « Dette et risques » (lignes `- **élevé** : … (<chemin>)`). Chaque risque de niveau élevé sera repris dans « Risques ». Ne refais pas le diagnostic : reprends ce que dit ce livrable, cité comme `analyse-projet.md`.
- **Code du projet** : avec Glob, cherche des fichiers de code (`.ts`, `.tsx`, `.js`, `.jsx`, `.vue`, `.dart`, `.py`, `.php`, `.rb`, `.go`, `.java`, `.kt`, `.swift`…) ou un manifeste de paquets, hors `node_modules/`, `build/`, `dist/` et `docs/`.
  - **Aucun code source** : c'est un développement à partir de zéro ; « Hypothèses » le dit avec les mots « développement à partir de zéro : le projet ne contient pas de code source ».
  - **Du code existe** : c'est l'évolution d'une application existante. Établis la liste des dossiers de code de premier et de deuxième niveau (ex. `<dossier>/`, `<dossier>/<sous-dossier>/`). Lis ceux que touchent les besoins (Read, Glob, Grep avec `glob`), pour situer chaque tâche dans des fichiers existants. Note les dossiers lus et ceux qui ne l'ont pas été : les premiers sont listés dans « Hypothèses » (« code existant pris en compte ; dossiers lus : … »), les seconds dans « Points non déterminés » (« dossiers non lus : … »). Un même dossier n'est jamais dans les deux listes.

## Étape 4 : découper et estimer

- **Lots** : regroupe les tâches en lots fonctionnels cohérents (`### Lot <n> : <nom>`). Chaque tâche de « Détail par lot » couvre au moins un besoin `Bnn` de l'entrée, cité dans la colonne « Besoins couverts » ; une tâche peut en couvrir plusieurs. Aucun identifiant `Bnn` inventé.
- **Estimations** : en jours, fourchette basse et haute, par pas de 0,5 jour, écrites avec une virgule décimale et sans unité dans la cellule (l'unité est dans l'en-tête de colonne) ; l'estimation haute est toujours supérieure ou égale à l'estimation basse.
- **Taille maximale** : aucune tâche n'a une estimation haute supérieure à 5 jours. Une tâche plus grosse est découpée en plusieurs tâches, chacune de 5 jours au plus en estimation haute.
- **Incertitude** : quand l'estimation haute est au moins le double de l'estimation basse, la colonne « Commentaire » explique l'incertitude (ce qui ferait monter la charge) et cite l'hypothèse (`Hn`, `Qnn`) ou le risque qui la cause.
- **Code existant** : quand le projet contient du code, chaque tâche de « Détail par lot » cite dans son commentaire, par son chemin relatif, au moins un fichier existant du projet qu'elle modifie, étend, appelle ou vérifie, lu ou repéré pendant l'étape 3, quelle que soit la nature de la tâche. Seule une tâche qui ne touche à aucun fichier existant en est dispensée, et son commentaire le dit explicitement (« aucun fichier existant concerné : nouveau fichier `<chemin>` à créer »). Un fichier à créer est présenté comme nouveau, jamais comme existant. Avant d'écrire, vérifie ligne par ligne que chaque tâche de lot respecte cette règle.
- **Activités transverses** (gestion de projet, recette, mise en production…) : des tâches estimées comme les autres, dans le tableau de « Activités transverses », proposées seulement quand l'entrée les justifie. Leur commentaire cite l'élément de l'entrée qui les justifie : un `Bnn`, une réponse `Qnn` ou une contrainte nommée. Sans élément justificatif, pas de tâche transverse. Leur colonne « Besoins couverts » porte les `Bnn` concernés, ou « aucun ».
- **Besoin non chiffrable** : un besoin trop imprécis pour être estimé (fonction non décrite, question qui le définit sans réponse) n'a aucune tâche. Il figure dans « Exclusions » avec la mention « non chiffrable en l'état » et l'information manquante (avec le `Qnn` qui la demande, s'il existe). Il n'est compté dans aucun total, sans provision ni ligne de réserve.
- **Hors périmètre de l'entrée** : chaque élément de la section « Hors périmètre » de l'entrée figure dans « Exclusions », avec sa raison.
- **Couverture** : chaque besoin `Bnn` de l'entrée apparaît soit dans la colonne « Besoins couverts » d'au moins une tâche, soit dans « Exclusions » avec la raison de l'exclusion. Vérifie-le besoin par besoin avant d'écrire.
- **Identifiants de tâches** : identifiants de tâches `C01`, `C02`…, sur deux chiffres, uniques, dans l'ordre d'apparition à la première exécution (lots puis activités transverses). À la relance, voir l'étape 7.
- **Totaux** : le total bas est la somme exacte des estimations basses de toutes les tâches (lots et activités transverses) ; de même pour le total haut. Calcule chaque somme avec `python3 -c 'print(<somme>)'` (voir « Aucune exécution »), en listant toutes les valeurs avec un point décimal, et recopie le résultat avec une virgule décimale. Aucun arrondi, aucune marge ajoutée.

## Étape 5 : hypothèses, risques et points non déterminés

- **Hypothèses** : numérotées `H1`, `H2`… Chaque question `Qnn` sans réponse qui influe sur une estimation donne une hypothèse qui cite son identifiant et les tâches `Cnn` concernées. Une réponse remplie est un fait : elle n'est pas présentée comme une hypothèse, et la tâche ou le besoin qui s'en sert cite « réponse à Qnn ». Y figurent aussi : « développement à partir de zéro » ou « code existant pris en compte ; dossiers lus : … » (étape 3), et les hypothèses que tu poses toi-même pour estimer.
- **Risques** : chaque risque indique, sur sa ligne, les tâches `Cnn` qu'il affecte (ou « aucune tâche affectée ») et si son effet est déjà inclus dans l'estimation haute. Chaque risque de niveau élevé de la section « Dette et risques » de `docs/wf/analyse-projet.md` y est repris, en citant `analyse-projet.md` : il affecte chaque tâche qui touche un fichier qu'il cite ; s'il n'en touche aucun, il porte « aucune tâche affectée ».
- **Points non déterminés** : dossiers de code non lus, date de l'entrée non déterminée, et tout ce qui n'a pas pu être établi. Quand l'entrée n'est pas un livrable de `wf-cadrage-besoin` (besoins numérotés par l'outil), recommande d'y passer : « besoins numérotés par wf-chiffrage : lancer `/wf-cadrage-besoin` sur ce fichier pour un cadrage complet (priorités, questions au client) ». S'il n'y a rien : « - Aucun. »

## Étape 6 : écrire le livrable

Récupère avec Bash, **avant d'écrire** : la date (`date +%F`), le commit (`git rev-parse --short HEAD`) et l'état du répertoire (`git status --porcelain`). Si `git rev-parse --short HEAD` échoue (pas de dépôt git, ou dépôt sans aucun commit), le commit est « non déterminé (aucun commit git) » et l'en-tête ne porte pas la mention « modifications non commitées », faute de commit de référence. Sinon, si `git status --porcelain` contient au moins une ligne qui ne concerne pas `docs/wf/chiffrage.md`, ajoute « modifications non commitées » après le commit. Le commit est toujours celui du projet au lancement, jamais celui qu'indiquent les livrables lus en entrée.

Écris le livrable avec Write, d'un seul tenant, selon ce modèle (les huit sections, en titres `##`, dans cet ordre, avec ces noms exacts ; `<nn>` et `<n>` sont des numéros, `<basse>` et `<haute>` des estimations) :

```markdown
# Chiffrage : <objet du besoin>

- Outil : wf-chiffrage
- Date : <AAAA-MM-JJ>
- Commit analysé : <hash court | non déterminé (aucun commit git)>[, modifications non commitées]
- Fichier d'entrée : <nom de fichier seul> (en-tête daté du <date de l'en-tête de l'entrée | date non déterminée>)
- Dernier identifiant attribué : C<nn>

## Synthèse

<2 à 4 phrases : ce qui est chiffré, nombre de lots et de tâches, principales hypothèses et exclusions.>

- Total bas : <somme> j
- Total haut : <somme> j

## Périmètre chiffré

- B<nn> : <libellé tel que dans l'entrée> (source : <nom de fichier seul>[, <section ou page>]) : C<nn>[, C<nn>].
- B<nn> : <libellé> (source : <nom de fichier seul>) : exclu, voir « Exclusions ».

## Détail par lot

### Lot <n> : <nom du lot>

| Identifiant | Tâche | Besoins couverts | Estimation basse (j) | Estimation haute (j) | Commentaire |
|---|---|---|---|---|---|
| C<nn> | <tâche> | B<nn>[, B<nn>] | <basse> | <haute> | <fichier existant concerné, précision, renvoi à une hypothèse ou à un risque> |

## Activités transverses

| Identifiant | Tâche | Besoins couverts | Estimation basse (j) | Estimation haute (j) | Commentaire |
|---|---|---|---|---|---|
| C<nn> | <activité> | <B<nn> ou aucun> | <basse> | <haute> | <élément de l'entrée qui la justifie : B<nn>, réponse à Q<nn> ou contrainte> |

- Total bas : <somme de toutes les tâches> j
- Total haut : <somme de toutes les tâches> j

## Hypothèses

- H<n> : <supposition retenue> (Q<nn> sans réponse) ; tâches concernées : C<nn>[, C<nn>].
- H<n> : <développement à partir de zéro : le projet ne contient pas de code source | code existant pris en compte ; dossiers lus : <dossier>/, <dossier>/>.

## Exclusions

- B<nn> : <libellé> : non chiffrable en l'état ; information manquante : <ce qu'il faut savoir>[ (voir Q<nn>)].
- <élément hors périmètre de l'entrée> : <raison> (source : <nom de fichier seul>).

## Risques

- <risque> (source : <analyse-projet.md | Q<nn> | nom de fichier seul>) : tâches affectées : C<nn>[, C<nn>] ; effet inclus dans l'estimation haute : <oui | non>.
- <risque> (source : analyse-projet.md) : aucune tâche affectée ; effet inclus dans l'estimation haute : non.

## Points non déterminés

- <information non établie, dossiers de code non lus> : non déterminé.
```

- **Section vide** : les huit sections sont toujours présentes. Une section sans élément contient la seule ligne « Aucun élément. » (ou « - Aucun. » pour « Points non déterminés »). Les deux tableaux restent présents avec leur en-tête de colonnes même si l'un est vide.
- Les totaux figurent deux fois, identiques : dans « Synthèse » et en fin de « Activités transverses », après le tableau.
- « Dernier identifiant attribué » : le plus grand `Cnn` jamais attribué, y compris s'il a été retiré depuis.
- Avant d'écrire, relis le texte : aucune adresse e-mail, aucun numéro de téléphone, aucun montant ni symbole monétaire, aucun chemin absolu, aucune estimation haute au-dessus de 5 jours ni inférieure à la basse, aucune valeur hors pas de 0,5.

## Étape 7 : relance sur un livrable existant

Le livrable précédent est relu, puis entièrement réécrit avec Write (un seul livrable dans le fichier, jamais l'ancien suivi du nouveau, aucune copie datée) :

- **Besoin inchangé** : un besoin dont l'identifiant et le libellé sont les mêmes dans l'entrée actuelle et dans « Périmètre chiffré » du livrable précédent. Chaque tâche de lot dont tous les besoins couverts sont inchangés conserve exactement son identifiant, son libellé de tâche, ses besoins couverts et ses deux estimations.
- **Besoin modifié** (même identifiant, libellé différent) : ses tâches gardent leur identifiant mais peuvent être réestimées, avec un commentaire qui le signale.
- **Besoin retiré de l'entrée** : ses tâches sont supprimées (le besoin peut être mentionné dans « Exclusions » s'il est passé hors périmètre).
- **Activité transverse** : elle garde son identifiant tant qu'elle reste justifiée. Ses estimations sont conservées si son périmètre n'a pas changé (mêmes besoins concernés, même élément justificatif) ; sinon, elles sont réévaluées, et son commentaire dit ce qui a changé (besoin ajouté ou retiré, contrainte modifiée). Une activité qui n'est plus justifiée est supprimée.
- **Identifiants de tâches**, à appliquer dans cet ordre :
  1. Une tâche conservée garde exactement son identifiant : jamais de renumérotation.
  2. Calcule `Cmax` : le plus grand entre le `Cnn` de la ligne « Dernier identifiant attribué » et le plus grand `Cnn` présent dans le livrable précédent.
  3. Tout identifiant inférieur ou égal à `Cmax` absent du nouveau livrable est retiré : il n'est jamais réattribué, même à une tâche qui semble lui correspondre, et même s'il comble un trou.
  4. Les nouvelles tâches reçoivent `Cmax + 1`, `Cmax + 2`…, dans l'ordre où tu les ajoutes.
  5. La ligne « Dernier identifiant attribué » porte ensuite le plus grand identifiant jamais attribué.
- Recalcule les totaux, mets à jour la date, le commit, le fichier d'entrée et la date de son en-tête.

## Message final

Court, en français : chemin du livrable écrit ou mis à jour, total bas et total haut, nombre de tâches, de besoins exclus et d'hypothèses. Aucune question à l'utilisateur. Si rien n'a été écrit, dis-le explicitement, avec la raison.
