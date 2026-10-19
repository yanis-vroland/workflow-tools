---
name: wf-recette
description: Génère ou met à jour docs/wf/recette.md, le cahier de recette du projet - cas de vérification manuelle tirés des critères d'acceptation des specs (docs/specs/), du livrable de wf-specs-tickets ou, à défaut, du code ; statuts et commentaires saisis à la main conservés à la relance, couverture et synthèse de la campagne. À utiliser avec /wf-recette [référence git], ou quand on demande un cahier, un plan ou une campagne de recette pour une livraison ou une version.
argument-hint: "[référence git]"
---

# wf-recette

Tu prépares, en français, le cahier de recette du projet ouvert dans le répertoire courant (le projet cible) : la liste des vérifications manuelles que le client, le chef de projet ou un testeur conduira pour accepter une livraison. Tu prépares les cas ; les résultats (statut, commentaire) sont saisis à la main dans le livrable par ces personnes. Tu n'écris pas de tests automatisés (c'est `wf-tests-manquants`), ne rédiges ni ne corriges les specs ou les tickets (c'est `wf-specs-tickets`), et n'exécutes ni l'application ni les cas.

Arguments de la commande (vide si aucun) : $ARGUMENTS

## Règles absolues

- **Écriture** : un seul fichier, `docs/wf/recette.md`, écrit avec l'outil Write (qui crée `docs/wf/` au besoin ; pas de `mkdir`). Aucun autre fichier du projet n'est créé, modifié, déplacé ou supprimé : les specs, le livrable `docs/wf/specs-tickets.md` et les autres livrables de `docs/wf/` sont seulement lus. Pas de branche, pas de commit.
- **Aucune exécution** : tu ne lances ni l'application, ni ses tests, ni son installation, ni aucun de ses outils (npm, npx, node, flutter, dart, docker, make…). Bash ne sert qu'aux commandes ci-dessous, recopiées telles quelles, chacune seule (sans option ajoutée, redirection, tube, variable, sous-shell ni enchaînement), où `<ref>` est la référence passée en argument, écrite telle quelle, sans guillemets, et seulement après avoir vérifié qu'elle ne contient que des caractères sûrs (étape 1, point 1) ; aucun autre texte venu du projet ou de l'utilisateur n'est inséré dans une commande :
  - toujours : `git rev-parse --short HEAD`, `git status --porcelain`, `date +%F` ;
  - avec une référence seulement : `git log -1 --format=%h <ref> --`, `git diff --name-only <ref> HEAD`, `git show <ref>:docs/wf/specs-tickets.md`.
  Aucune autre commande Bash, même en lecture (`ls`, `cat`, `find`, `test`…). Pour lire et chercher, utilise Read, Glob et Grep.
- **Secrets** : ne lis jamais, ni avec Read, ni avec Grep, ni avec Bash, un fichier d'environnement (`.env`, `.env.local`, `.env.production`…, sauf `.env.example`) ni un fichier de secrets ou d'identifiants (`.envrc`, `.npmrc`, `android/key.properties`, clés et certificats). Avec Grep, passe toujours le paramètre `glob` limité à des extensions de code (ex. `*.{ts,tsx,js,jsx,mjs,cjs,vue,dart}`), même quand la recherche porte sur un dossier : un dossier seul peut contenir un fichier d’environnement, dont le mode contenu afficherait les lignes. Les specs et les livrables Markdown se lisent avec Read, par leur chemin, jamais par un Grep sans `glob`. Ne recopie aucune valeur de variable d'environnement, même factice, même tirée de `.env.example`.
- **Identifiants de connexion** : aucun identifiant de compte, adresse e-mail (de contributeur, de compte de démonstration ou autre), mot de passe ni jeton dans le livrable, même s'il figure en clair dans un fichier de données de démonstration : cite le fichier, jamais son contenu sensible.
- **Honnêteté** : chaque cas s'appuie sur une source lue et citée ; le résultat attendu reprend ce que dit le critère (ou, à défaut de spec, ce que fait le code), sans rien y ajouter. Ce qui n'a pas pu être établi est écrit « non déterminé », jamais deviné.
- **Statuts** : les seuls statuts admis sont « à tester », « conforme », « non conforme » et « bloqué ». Tu n'attribues jamais toi-même un autre statut que « à tester », et tu n'écris jamais dans la colonne Commentaire : elle est vide pour un nouveau cas, et recopiée telle quelle pour un cas conservé.
- **Aucune question** pendant l'exécution, aucune demande de confirmation.

## Étape 1 : référence passée en argument

Sans argument, tout le projet est couvert : passe à l'étape 2.

Avec un argument, c'est une référence git (tag, branche ou commit) : la campagne ne porte que sur ce qui a changé depuis elle. Avant toute autre lecture :

1. Si l'argument contient autre chose que des lettres, chiffres, `.`, `_`, `/` et `-`, ou commence par `-`, ne lance aucune commande avec lui : il est introuvable (point 3).
2. Lance `git log -1 --format=%h <ref> --`. Si la commande réussit, sa sortie est le commit de la référence (hash court) : retiens la référence et ce commit.
3. Si la commande échoue (référence inconnue, ou répertoire hors dépôt git), n'écris ni ne modifie aucun livrable, même si `docs/wf/recette.md` existe déjà, et termine par ce message : « Référence <ref> introuvable dans le dépôt : aucun cahier de recette n'a été écrit ni modifié. »

## Étape 2 : inventaire des sources

Avec Glob et Read :

- **Specs** : les fichiers `docs/specs/*.md`. Une spec est une source de cas si elle contient des critères d'acceptation numérotés (`CA1`, `CA2`…). Relève sa ligne de statut (ex. `Statut : brouillon`) : une spec dont le statut contient « brouillon » est une **spec brouillon**. Une spec sans critère numéroté est citée dans « Périmètre et sources » et dans « Points non déterminés » (« aucun critère numéroté »), sans produire de cas.
- **Livrable de `wf-specs-tickets`** : `docs/wf/specs-tickets.md`, s'il existe (spec 006, contrat avec cet outil). Chaque ticket y est une sous-section titrée `Tnn : <titre>` (`T01`, `T02`…), dont la rubrique « Critères d'acceptation » contient des critères numérotés `CA1`, `CA2`… propres au ticket, cités ailleurs sous la forme `Tnn-CAn`. Lis-le sans jamais le modifier.
- **Code** : fichiers de code (`.ts`, `.tsx`, `.js`, `.jsx`, `.vue`, `.dart`, `.py`, `.rb`, `.php`, `.go`, `.rs`, `.java`, `.kt`, `.swift`, `.cs`…) et manifestes (`package.json`, `pubspec.yaml`, `pyproject.toml`, `requirements.txt`, `go.mod`, `Cargo.toml`, `composer.json`, `Gemfile`, `pom.xml`, `build.gradle`), hors `node_modules/`, dossiers de build et fichiers générés. Stack : JavaScript/TypeScript (`package.json`) et Flutter (`pubspec.yaml`) sont couvertes en v1 ; toute autre stack (Python, PHP, Go…) est nommée d'après son manifeste ou ses fichiers.

Puis choisis le mode :

- **Mode specs** : au moins une spec à critères numérotés, ou un livrable `wf-specs-tickets` avec au moins un ticket. Les cas viennent des critères ; le code sert seulement aux prérequis et à la couverture.
- **Mode code** : ni l'un ni l'autre, et du code d'une stack couverte. Les cas sont déduits du code.
- **Stack non couverte** : ni spec ni livrable `wf-specs-tickets`, et un code qui ne relève ni de JavaScript/TypeScript ni de Flutter. N'écris aucun livrable, ne déduis aucun cas du code, et termine par ce message : « Stack <nom> non couverte en v1 : aucun cas n'est déduit du code et aucun cahier de recette n'a été écrit. »
- **Rien à recetter** : ni code source, ni spec, ni livrable `wf-specs-tickets` (répertoire vide, ou seulement des documents comme un brief ou des notes, qui ne sont pas des sources de cas). N'écris rien et termine par ce message : « Aucun code source ni aucune spec trouvé dans ce répertoire : aucun cahier de recette n'a été écrit. »

## Étape 3 : périmètre de la campagne (avec une référence seulement)

1. `git diff --name-only <ref> HEAD` : liste des fichiers modifiés depuis la référence.
2. Specs : seules les specs de cette liste produisent des cas (tous leurs critères).
3. Tickets : si `docs/wf/specs-tickets.md` est dans la liste, lance `git show <ref>:docs/wf/specs-tickets.md`. Un ticket est **modifié** si le contenu de sa sous-section `Tnn` (de son titre jusqu'au titre suivant de même niveau ou de niveau supérieur) diffère entre cette sortie et le fichier actuel, ou s'il n'existait pas à la référence ; si la commande échoue (fichier absent à la référence), tous les tickets sont modifiés. Seuls les tickets modifiés produisent des cas. Si le fichier n'est pas dans la liste, aucun ticket n'en produit.
4. Code : en mode code, seuls les fichiers de code de la liste produisent des cas ; en mode specs, « Fonctionnalités sans spec » ne porte que sur les fichiers de code de la liste.
5. Tout le reste (specs, tickets et fichiers non modifiés) est lu pour comprendre le projet, mais ne produit aucun cas.

## Étape 4 : en-tête

- Date : `date +%F` (format AAAA-MM-JJ).
- Commit : `git rev-parse --short HEAD`. Si la commande échoue (pas un dépôt git), écris « hors git ».
- `git status --porcelain` : si la sortie contient au moins une ligne qui ne concerne pas `docs/wf/recette.md`, ajoute la mention « modifications non commitées ». Sinon, ne l'écris pas.

## Étape 5 : cahier existant

Si `docs/wf/recette.md` existe, lis-le d'abord : c'est une relance (nouvelle campagne). Tu le réécriras en entier avec Write, un seul cahier dans le fichier, sans copie datée ni numérotée (les campagnes précédentes restent dans l'historique git). Relève :

- chaque cas du tableau : ID, Fonctionnalité, Source, Statut, Commentaire ;
- le **dernier identifiant attribué** : le plus grand entre la ligne « Dernier identifiant attribué » de l'en-tête et tous les `REC-nnn` présents dans le fichier (tableau, « Cas hors campagne », « Cas retirés »).

## Étape 6 : établir les cas

**Vérifiable manuellement ou non.** Un critère est vérifiable manuellement si une personne peut le constater en utilisant l'application, par ce qu'elle affiche, produit ou envoie. Ne l'est pas un critère qui porte sur un comportement interne, non observable depuis l'application, sur une performance mesurée, qui exige une mesure outillée, ou sur une propriété du code lui-même. Un critère non vérifiable manuellement ne produit aucun cas : il va dans « Critères non recettables manuellement », avec sa source et la raison.

**Mode specs.** Pour chaque critère vérifiable manuellement de chaque spec et de chaque ticket du périmètre, au moins un cas (un critère qui mêle plusieurs vérifications peut en donner plusieurs). Un cas n'a qu'une source :

- critère de spec : `` `docs/specs/<fichier>.md#CAn` `` ; pour une spec brouillon, suivi de « (spec brouillon) » : `` `docs/specs/<fichier>.md#CAn` (spec brouillon) `` ;
- critère de ticket : `` `docs/wf/specs-tickets.md#Tnn-CAn` ``.

Ne cite jamais un critère, un ticket ou une spec qui n'existe pas.

**Mode code.** Déduis les cas des routes d'API, des pages et écrans, et des formulaires et de leurs validations (routeurs du framework HTTP, pages et routes du framework web, écrans et routes Flutter). Chaque cas décrit un comportement observable ; sa colonne Source cite le fichier de code (`` `<chemin>` ``, éventuellement suivi de `:<ligne>`). Le résultat attendu décrit ce que fait le code aujourd'hui, jamais ce qu'il devrait faire.

**Remplir un cas.**

- Fonctionnalité : quelques mots.
- Préconditions : rôle de l'utilisateur, données nécessaires (« aucune » si rien).
- Étapes : actions numérotées, séparées par `<br>` dans la cellule.
- Résultat attendu : ce que la personne doit constater, tiré de la source.
- Statut : « à tester » ; Commentaire : vide.
- Aucune barre verticale dans une cellule (elle casserait le tableau) : remplace-la par « / ».

**Relance : rapprocher avec le cahier existant.**

1. Un cas existant dont la source existe toujours et entre dans le périmètre de la campagne est conservé : même ID, même Statut, même Commentaire, recopiés mot pour mot (jamais reformulés, complétés ni effacés). Fonctionnalité, Préconditions, Étapes et Résultat attendu sont mis à jour si la source a changé. Deux sources sont identiques si elles citent le même chemin et le même critère, avec ou sans la mention « (spec brouillon) » ; si plusieurs cas existants ont la même source, rapproche-les par leur fonctionnalité.
2. Un cas existant dont la source a disparu (spec supprimée, ticket supprimé, critère supprimé ou renuméroté, fichier de code supprimé en mode code) est retiré du tableau et listé sous « Cas retirés », avec son ID, sa fonctionnalité, son ancienne source et son dernier statut.
3. Un cas existant dont la source existe toujours mais n'entre pas dans le périmètre de cette campagne (hors des changements depuis la référence, ou devenue non recettable manuellement) est retiré du tableau et listé sous « Cas hors campagne », avec son ID, sa fonctionnalité, sa source, son dernier statut et son dernier commentaire.
4. Un nouveau cas reçoit un identifiant jamais utilisé : le dernier identifiant attribué (étape 5) plus un, puis plus deux…, dans l'ordre où tu les ajoutes. Un identifiant retiré, à cette relance ou avant, n'est jamais réattribué, même pour combler un trou. Sans cahier existant, la numérotation commence à `REC-001`.
5. La ligne « Dernier identifiant attribué » de l'en-tête porte le plus grand identifiant attribué, ancien ou nouveau. Avant d'écrire, vérifie que chaque identifiant est unique dans le livrable.

## Modèle du livrable

Titres de section en `##`, exactement dans cet ordre, sans table des matières. Tableau des cas trié par identifiant.

```markdown
# Cahier de recette de <nom du projet>

Outil : wf-recette · Date : AAAA-MM-JJ · Commit : <sha court ou « hors git »>[ · modifications non commitées]
Dernier identifiant attribué : REC-<nnn>

## Périmètre et sources

[Campagne limitée aux changements depuis la référence `<ref>` (commit `<sha court>`).]
[Avertissement du mode code, voir plus bas.]

- Specs : `docs/specs/<fichier>.md`[ (spec brouillon)], …
- Livrable de wf-specs-tickets : `docs/wf/specs-tickets.md` (tickets T01 à Tnn)
- Code : `<dossier ou fichier>`, …

## Prérequis

- Rôles nécessaires à la recette : `<rôle>` (`<fichier où il est défini>`), …
- Données de démonstration : `<fichier>` (<ce qu'il crée, sans identifiant ni mot de passe>)
- <Autre prérequis tiré d'un fichier, avec sa source.>

## Cas de recette

| ID | Fonctionnalité | Préconditions | Étapes | Résultat attendu | Source | Statut | Commentaire |
|---|---|---|---|---|---|---|---|
| REC-001 | <fonctionnalité> | <préconditions> | 1. <action><br>2. <action> | <résultat attendu> | `docs/specs/<fichier>.md#CA1` | à tester |  |

## Couverture

### Critères non recettables manuellement

- `<source>` : <critère en quelques mots>. Raison : <pourquoi il ne se vérifie pas à la main>.

### Fonctionnalités sans spec

- <Route `MÉTHODE /chemin` ou écran `<nom>`> (`<fichier>`)

### Cas hors campagne

- REC-<nnn> : <fonctionnalité> (`<source>`), dernier statut : <statut>, dernier commentaire : <commentaire ou « aucun »>.

### Cas retirés

- REC-<nnn> : <fonctionnalité> (`<ancienne source>`), dernier statut : <statut>.

## Synthèse de la campagne

- à tester : <n>
- conforme : <n>
- non conforme : <n>
- bloqué : <n>
- Total : <n>

## Points non déterminés

- <Point, avec les fichiers concernés.>
```

## Remplir chaque section

**En-tête** : outil, date, commit (ou « hors git ») et, le cas échéant, « modifications non commitées » (étape 4) ; puis la ligne « Dernier identifiant attribué ». Aucune adresse e-mail.

**Périmètre et sources** : chaque source lue, avec son chemin relatif à la racine : chaque spec (avec « (spec brouillon) » le cas échéant), le livrable `docs/wf/specs-tickets.md` s'il a été lu, et le code lu (dossiers ou fichiers). Une source absente peut être dite absente, jamais présentée comme lue. Avec une référence, la première ligne indique la référence et son commit (étape 1), sur la même ligne. En mode code, ajoute cet avertissement : « Aucune spec ni livrable wf-specs-tickets : les cas sont déduits du code. Les résultats attendus décrivent le comportement actuel du code, et non un comportement spécifié : ils doivent être validés par le client avant la recette. »

**Prérequis** : les rôles utilisateurs nécessaires à la recette (au moins ceux qu'utilisent les préconditions des cas), chacun avec le fichier qui le définit (schéma, énumération, contrôle d'accès) ; les fichiers de données de démonstration (seeds, fixtures), cités par leur chemin, avec ce qu'ils créent en termes généraux. Jamais d'identifiant de connexion, d'adresse e-mail, de mot de passe, de jeton ni de valeur de variable d'environnement : si un mot de passe est fourni par une variable, nomme au plus la variable. Sans rôle ni donnée de démonstration identifiés, écris « non déterminé » et reprends-le dans « Points non déterminés ».

**Cas de recette** : le tableau, aux huit colonnes ci-dessus, dans cet ordre, une ligne par cas. Sans aucun cas (ex. campagne sur une référence sans changement), garde l'en-tête du tableau et ajoute sous lui « Aucun cas pour cette campagne. »

**Couverture** : les quatre sous-sections, toujours présentes, chacune avec « - Aucun. » quand elle est vide.
- « Critères non recettables manuellement » : chaque critère écarté à l'étape 6, avec sa source et la raison.
- « Fonctionnalités sans spec » (mode specs) : chaque route d'API ou écran du code qu'aucune spec ni aucun ticket ne mentionne, avec son fichier. Une route ou un écran est mentionné si un critère, un besoin ou un ticket décrit ce qu'il fait ; une simple précondition d’accès ou le nom d’une entité ne suffit pas. En mode code, écris « Sans objet : aucune spec ni livrable wf-specs-tickets, les cas sont déduits du code. » En stack non couverte avec des specs, écris « non déterminé (stack <nom> non couverte en v1) ».
- « Cas hors campagne » et « Cas retirés » : voir l'étape 6 (relance).

**Synthèse de la campagne** : le nombre de cas du tableau pour chacun des quatre statuts admis (zéro compris) et le total. Compte les lignes du tableau final après l'avoir écrit dans ta réponse, et vérifie que la somme des quatre nombres est égale au total et au nombre de lignes du tableau. Les cas hors campagne et retirés ne comptent pas.

**Points non déterminés** : liste à puces de ce qui n'a pas pu être établi : chaque spec brouillon (« `docs/specs/<fichier>.md` : spec au statut brouillon, cas à confirmer quand elle sera validée »), spec sans statut ou sans critère numéroté, ticket sans critère, rôle ou donnée de démonstration non identifié, et tout autre point non déterminé. S'il n'y a rien : « - Aucun. »

## Fin

Écris le cahier avec Write dans `docs/wf/recette.md`, puis termine par un message court : chemin du livrable, création ou mise à jour, nombre de cas (dont nouveaux), de cas retirés et de critères non recettables manuellement. Si rien n'a été écrit, dis-le explicitement avec la raison (référence introuvable, stack non couverte, rien à recetter).
