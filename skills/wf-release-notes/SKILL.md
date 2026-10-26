---
name: wf-release-notes
description: Génère les notes de version d'une application web ou mobile à partir de l'historique git (par défaut du dernier tag de version à HEAD), pour le client et les utilisateurs non techniques, et les ajoute en tête de docs/wf/release-notes.md (une section par version, sans toucher aux précédentes). À utiliser avec /wf-release-notes avant de livrer une version, ou quand on demande des notes de version ou un « quoi de neuf ».
argument-hint: "[<référence basse> <référence haute>] [--version <numéro>]"
---

# wf-release-notes

Tu rédiges, en français, les notes de version du projet ouvert dans le répertoire courant (le projet cible), à partir de son historique git entre deux références. Les notes s'adressent au client et aux utilisateurs finaux, qui ne sont pas développeurs ; le détail technique reste dans la sous-section « Références ».

Arguments de la commande (vide si aucun) : $ARGUMENTS

Le chemin `docs/wf/release-notes.md`, le titre des sections `## Version <numéro> (<AAAA-MM-JJ>)` et les noms des six sous-sections sont un contrat : `wf-publication-store` reprend la sous-section « Nouveautés » de la section la plus récente. Respecte-les à la lettre.

## Règles absolues

- **Écriture** : le seul fichier écrit est `docs/wf/release-notes.md`, créé avec l'outil Write (qui crée `docs/wf/` au besoin ; pas de `mkdir`) ou modifié avec l'outil Edit. Aucun autre fichier du projet n'est créé, modifié ou supprimé : ni `CHANGELOG.md`, ni le numéro de version d'un manifeste, ni les livrables des autres outils. Aucun tag, aucune branche, aucun commit, aucune publication de release.
- **Entrée** : l'historique git, et rien d'autre. Ne lis aucun fichier du projet avec Read, Glob ou Grep, à la seule exception de `docs/wf/release-notes.md` s'il existe. Le contenu du manifeste se lit par `git show` (étape 4).
- **Bash** : seulement les commandes données dans cette skill, recopiées telles quelles en remplaçant les `<…>`, sans redirection vers un fichier ni autre commande. Aucune commande git qui modifie le dépôt (add, commit, tag, checkout, switch, stash, reset, fetch, pull…), aucune installation ni exécution du projet.
- **Valeurs insérées dans une commande** : une référence passée en argument n'entre dans le shell que par le heredoc de l'étape 2, qui la valide avant usage. Partout ailleurs, les emplacements `<bas>`, `<haut>`, `<premier commit>` et `<hash>` ne reçoivent que des hash hexadécimaux produits par git (étapes 2, 3 et 5), entre apostrophes et après `--end-of-options`. Une valeur qui commence par `-` n'est jamais insérée dans une commande : elle est refusée (étape 2), pour qu'aucune référence ne devienne une option de git. Le numéro de `--version` et le texte des arguments ne sont jamais insérés dans une commande.
- **Modifications non commitées** : elles ne sont jamais prises en compte dans les notes. N'utilise jamais `git diff` sur l'arbre de travail ni `git diff HEAD` : seuls les commits de la plage comptent. Elles ne servent qu'à la mention de l'en-tête (étape 7).
- **Secrets** : ne lis jamais le contenu ni le diff d'un fichier d'environnement (`.env`, `.env.local`, `.env.staging`…, `.env.example` compris, inutile ici) ni d'un fichier d'identifiants (`.envrc`, `.npmrc`, `key.properties`, clés et certificats), même versionné dans le dépôt : toute commande `git show` qui affiche un diff ou une liste de fichiers porte les exclusions de l'étape 6. Seules les lectures du manifeste de l'étape 4, qui visent un fichier nommé (`package.json` ou `pubspec.yaml`), en sont dispensées. Aucune valeur de ces fichiers dans le livrable.
- **Données personnelles** : aucune adresse e-mail et aucun nom de contributeur dans le livrable, y compris ceux des lignes `Co-Authored-By:` ou `Signed-off-by:` des messages. N'utilise aucun format git qui affiche l'auteur ou le committer, ni aucune commande qui liste les contributeurs.
- **Honnêteté** : chaque entrée s'appuie sur un ou plusieurs commits de la plage, cités dans « Références ». Rien n'est inventé (ni fonctionnalité, ni bénéfice, ni action requise) ; ce qui n'a pas pu être établi est « non déterminé » et figure dans « Points non déterminés ».
- **Aucune question** pendant l'exécution.

## Étape 1 : dépôt git

```bash
git rev-parse --is-inside-work-tree
git rev-parse -q --verify HEAD
git ls-files -- . | head -n 1
```

Le projet est « dans git » si la première commande affiche `true`, la deuxième un hash et la troisième un fichier. Sinon il est « hors git » (pas de dépôt, dépôt sans commit, ou dépôt parent qui ne suit pas ce dossier) : n'écris rien, ne lis rien d'autre, et termine par ce message : « Ce projet n'est pas un dépôt git avec un historique : impossible d'établir les changements de la version. Aucun livrable n'a été écrit. »

Puis : `git rev-parse --is-shallow-repository` (`true` : clone superficiel, voir étape 3).

## Étape 2 : arguments

Découpe les arguments :

- `--version <numéro>` (ou `--version=<numéro>`) : numéro de version imposé. Il doit correspondre à `^[0-9A-Za-z.+-]+$` sans commencer par `-` ; sinon, sans aucune commande, termine par : « `--version` : numéro de version refusé (lettres, chiffres, `.`, `+` et `-` seulement, sans `-` initial) : aucun livrable n'a été écrit ni modifié. »
- Les autres arguments sont des références git (tag, branche, hash, ou expression comme `HEAD~3`, `<tag>^`, `<branche>@{1}`) : zéro, une ou deux. Une seule référence est la borne basse, la borne haute est alors `HEAD`. Plus de deux références : indique la syntaxe `/wf-release-notes [<référence basse> <référence haute>] [--version <numéro>]` et arrête-toi sans rien écrire.
- Avant toute commande, examine chaque référence : vide, commençant par `-`, sur plusieurs lignes, ou contenant un autre caractère que lettres, chiffres, `.`, `_`, `/`, `~`, `^`, `@`, `{`, `}`, `+` et `-` (apostrophe, guillemet, espace, `$`, accent grave…) : ne lance aucune commande, n'écris rien, et termine par : « Référence `<référence>` : référence refusée : caractères non pris en charge. Aucun livrable n'a été écrit ni modifié. »

Résous ensuite chaque référence admise en hash de commit, une commande par référence, la référence recopiée seule sur la ligne du heredoc (délimiteur entre apostrophes : rien n'y est interprété) puis validée à nouveau par bash :

```bash
IFS= read -r ref <<'WF_FIN_REF'
<référence>
WF_FIN_REF
case $ref in '' | -* | *[!A-Za-z0-9._/~^@{}+-]*) echo "référence refusée : caractères non pris en charge" ;; *) git rev-parse -q --verify --end-of-options "$ref^{commit}" || echo "référence inexistante" ;; esac
```

- Sortie : le hash complet du commit. C'est lui, et non le nom, qui remplace `<bas>` ou `<haut>` dans toutes les commandes suivantes.
- « référence refusée : caractères non pris en charge » : termine par le message de refus ci-dessus.
- « référence inexistante » : n'écris rien, ne modifie rien, et termine par : « La référence `<référence>` n'existe pas dans ce dépôt : aucun livrable n'a été écrit ni modifié. » (en clone superficiel, ajoute qu'elle est peut-être absente de l'historique tronqué).

Sans référence haute, résous `HEAD` de la même façon.

## Étape 3 : plage

La plage va de la borne basse (exclue) à la borne haute (incluse). Garde les noms des bornes tels qu'ils ont été passés ou trouvés (`v2.3.0`, `main`, `HEAD`) : c'est sous ce nom, jamais sous la forme d'un hash, que la ligne « Plage » les cite.

- Deux références : celles-ci, dans l'ordre donné.
- Aucune référence : borne haute `HEAD`, borne basse le dernier tag de version accessible depuis `HEAD`. Un tag de version a la forme `X.Y.Z` ou `vX.Y.Z` (expression `^v?[0-9]+\.[0-9]+\.[0-9]+$` ; un tag comme `v2.0.0-rc.1` ou `release-3` n'en est pas un) :

  ```bash
  git log --format=%D --decorate-refs=refs/tags/ HEAD | tr ',' '\n' | sed -n 's/^ *tag: //p' | grep -m1 -E '^v?[0-9]+\.[0-9]+\.[0-9]+$'
  ```

  Le tag trouvé est résolu en hash par la commande de l'étape 2, comme une référence passée en argument.

- Pas de borne basse (aucun tag de version) : la plage part du premier commit du dépôt, inclus. Relève-le, avec sa date :

  ```bash
  git rev-list --max-parents=0 --abbrev-commit HEAD
  git log -1 --format='%h %cs' --end-of-options '<premier commit>'
  ```

  « Points non déterminés » le signale : « aucun tag de version accessible depuis `HEAD` : la plage part du premier commit du dépôt (`<hash>`) ».
- Clone superficiel (étape 1) sans borne basse trouvée : le premier commit relevé ci-dessus est seulement le premier commit disponible, la borne basse réelle manque à l'historique. « Points non déterminés » le signale à la place de la mention précédente : « clone superficiel : l'historique ne contient pas la borne basse de la plage ; premier commit réellement disponible : `<hash>` (<date>) ; les commits antérieurs ne sont pas couverts ».

Compte les commits, hors commits de fusion (sans borne basse, l'emplacement devient `'<haut>'`) :

```bash
git rev-list --count --no-merges --end-of-options '<bas>..<haut>'
```

Zéro : n'écris rien, ne modifie rien, et termine par : « La plage de `<bas>` (exclu) à `<haut>` (inclus) ne contient aucun commit : aucun livrable n'a été écrit ni modifié. »

## Étape 4 : numéro de version

1. `--version` passé : ce numéro, source « passé en argument ».
2. Sinon, le manifeste à la racine du projet, tel qu'il est dans le commit de la borne haute (une modification non commitée du manifeste n'est pas prise en compte) : d'abord `package.json`, puis `pubspec.yaml` ; une commande échoue si le fichier n'existe pas.

   ```bash
   git show --end-of-options '<haut>:./package.json' | grep -m1 '"version"'
   git show --end-of-options '<haut>:./pubspec.yaml' | grep -m1 -E '^version:'
   ```

   Source : « lu dans `package.json` » ou « lu dans `pubspec.yaml` ».
3. Sinon (aucun manifeste, ou sans champ `version`) : le titre porte « Version non déterminée » et « Points non déterminés » le signale, en nommant les fichiers cherchés.

Le titre n'affiche pas le numéro de build : tout ce qui suit `+` est retiré (`1.4.0+42` dans `pubspec.yaml` donne `Version 1.4.0`). Ne déduis jamais le numéro des types de commits ni d'un tag.

Date du titre : date du commit de la borne haute.

```bash
git log -1 --format=%cs --end-of-options '<haut>'
```

## Étape 5 : commits de la plage

```bash
git log --no-merges --reverse --format='@@@ %h%n%B' --end-of-options '<bas>..<haut>'
```

(sans borne basse : `'<haut>'`)

Chaque bloc commence par `@@@ <hash court>`, suivi du message complet (sujet, corps, pieds). Les commits de fusion sont exclus : ils n'apparaissent nulle part dans le livrable, mais les commits des branches fusionnées sont dans la plage et comptent normalement.

## Étape 6 : classer

Sujet au format Conventional Commits : `<type>(<portée>)!: <description>`, portée et `!` facultatifs.

| Commit | Destination |
|---|---|
| marqué `!`, ou dont le message contient `BREAKING CHANGE:` (ou `BREAKING-CHANGE:`), quel que soit son type | Points d'attention (seulement là) |
| `feat` | Nouveautés |
| `perf` | Améliorations |
| `fix` | Corrections, sauf règle « correction d'une nouveauté » |
| `chore`, `ci`, `test`, `refactor`, `build`, `style`, `docs` | aucune entrée : « sans entrée » avec son type |
| `revert` (ou sujet `Revert "…"`) | voir « annulations » |
| autre type, ou sujet hors convention | classé d'après son message et son diff, voir « hors convention » |

**Regroupement** : plusieurs commits qui portent sur la même fonctionnalité (même portée et même objet décrit, ex. un formulaire de saisie puis son tri par colonne) produisent une seule entrée, qui les cite tous. Deux fonctionnalités distinctes d'un même module restent deux entrées.

**Correction d'une nouveauté** : un `fix` qui corrige une fonctionnalité introduite par un `feat` de la même plage (même portée et même objet, ou diff qui touche les fichiers de ce `feat`) ne produit aucune entrée dans « Corrections » : il est rattaché à l'entrée de cette fonctionnalité dans « Nouveautés ». Les utilisateurs n'ont jamais vu le défaut.

**Annulations** : un commit et le commit qui l'annule, tous deux dans la plage (le revert cite le hash ou le sujet de l'annulé), ne produisent aucune entrée : « sans entrée » pour les deux. Un revert dont le commit annulé est hors de la plage : « Points non déterminés », avec son hash court (« annulation d'un commit antérieur à la plage : effet pour les utilisateurs non déterminé »).

**Hors convention** : lis la liste des fichiers modifiés, puis si besoin le diff, toujours avec ces exclusions :

```bash
git show --stat --format= --end-of-options '<hash>' -- . ':(exclude,glob)**/.env*' ':(exclude,glob)**/.envrc' ':(exclude,glob)**/.npmrc' ':(exclude,glob)**/key.properties' ':(exclude,glob)**/*.pem' ':(exclude,glob)**/*.key' ':(exclude,glob)**/*.p12' ':(exclude,glob)**/*.jks'
git show --format= --end-of-options '<hash>' -- . ':(exclude,glob)**/.env*' ':(exclude,glob)**/.envrc' ':(exclude,glob)**/.npmrc' ':(exclude,glob)**/key.properties' ':(exclude,glob)**/*.pem' ':(exclude,glob)**/*.key' ':(exclude,glob)**/*.p12' ':(exclude,glob)**/*.jks'
```

- Le message et le diff montrent clairement une nouvelle fonctionnalité, une amélioration ou une correction visible : classe-le comme tel.
- Ils montrent un travail sans effet pour les utilisateurs (documentation, tests, outillage, configuration de build) : « sans entrée », avec le type retenu et la mention « hors convention » (ex. « sans entrée (hors convention, docs d'après son diff) »).
- Sinon : aucune entrée ; il figure dans « Points non déterminés » avec son hash court (« commit hors convention non classé : <sujet> ») et dans « Références » comme « sans entrée (hors convention, non classé) ».

Les mêmes commandes servent, au besoin, pour un regroupement ou une correction d'une nouveauté incertains. Jamais de `git show` sans ces exclusions, ni de `git log -p`.

## Étape 7 : en-tête

- Date : `date +%F`.
- Commit analysé : le hash court de la borne haute de la plage (pas forcément `HEAD`) : `git rev-parse --short --end-of-options '<haut>'`.
- `git status --porcelain` : si la sortie contient au moins une ligne qui ne concerne pas `docs/wf/release-notes.md`, ajoute « modifications non commitées » à l'en-tête (elles restent hors des notes).

## Modèle du livrable

Sous-sections dans cet ordre. Une sous-section sans entrée est omise, sauf « Références », toujours présente.

```markdown
# Notes de version

Outil : wf-release-notes · Date : AAAA-MM-JJ · Commit : <hash court de la borne haute>[ · modifications non commitées]

## Version <numéro> (<AAAA-MM-JJ>)

Plage : de `<bas>` (exclu) à `<haut>` (inclus), <n> commits[, hors commits de fusion]. Numéro de version <passé en argument | lu dans `package.json` | lu dans `pubspec.yaml` | non déterminé>.

### Nouveautés

- <Ce que l'utilisateur peut désormais faire.>

### Améliorations

- <Ce qui est plus rapide ou plus fluide.>

### Corrections

- <Le problème que l'utilisateur rencontrait, désormais corrigé.>

### Points d'attention

- <Changement cassant.> Action requise : <action décrite par le commit>.
- <Changement cassant, sans action décrite> : action requise non déterminée.

### Références

- Nouveautés, <libellé court de l'entrée> : `<hash>`, `<hash>` (<#12, PROJ-42>)
- `<hash>` : sans entrée (<type>)

### Points non déterminés

- <Point, avec le hash court du commit concerné s'il y en a un.>
```

Sans aucun tag : « Plage : du premier commit du dépôt (inclus) à `<haut>` (inclus) ». Titre sans numéro : `## Version non déterminée (<AAAA-MM-JJ>)`.

## Rédiger

**Entrées** (Nouveautés, Améliorations, Corrections, Points d'attention) : une phrase par entrée, pour un client ou un utilisateur non développeur : ce qui change pour lui, tiré du message (et du diff au besoin). Jamais de chemin de fichier, de nom de fonction ou de classe, de hash, de type ou de portée Conventional Commits, ni de jargon technique. Un nom de champ ou d'option peut figurer dans un point d'attention seulement si l'action requise l'exige.

**Points d'attention** : décris le changement, puis l'action requise de l'utilisateur ou du client, reformulée d'après le message du commit (sujet, corps, texte de `BREAKING CHANGE:`) quand il la décrit. S'il ne la décrit pas, écris exactement « action requise non déterminée », sans en inventer.

**Aucune entrée** dans les quatre sous-sections : écris, sous la ligne « Plage », la phrase « Aucun changement visible pour les utilisateurs. » ; « Références » liste quand même chaque commit.

**Références** : chaque commit de la plage y figure exactement une fois, par son hash court entre accents graves, et aucun autre hash n'apparaît sur sa ligne.
- Une ligne par entrée : la sous-section, un libellé court, puis les hash de tous ses commits (regroupés, corrections rattachées), et les numéros de PR (`#12`, `!12`) ou de ticket (ex. `PROJ-42`, identifiant entre parenthèses en fin de sujet) cités dans leurs messages.
- Une ligne par commit sans entrée : `` `<hash>` : sans entrée (<type>) ``. Pour une annulation dans la plage : « sans entrée (<type>, annulé dans la plage) » pour l'annulé, « sans entrée (revert) » pour l'annulation, sans citer l'autre hash.
- Les commits de fusion n'y figurent pas.

**Points non déterminés** : liste à puces de ce qui n'a pas pu être établi (version, absence de tag, clone superficiel, commits non classés, annulations hors plage). Omise si vide.

## Écrire le livrable

**Absent** : écris-le avec Write : titre, en-tête, puis la section de version.

**Présent** : lis-le avec Read, puis modifie-le uniquement avec Edit, sans jamais le réécrire en entier, pour que le reste du fichier reste identique octet pour octet, y compris les retouches faites à la main :

1. En-tête : un Edit qui remplace la seule ligne `Outil : wf-release-notes · …` par la nouvelle (date, commit, mention). Sans cette ligne, insère-la sous le titre `#`.
2. Section du même numéro déjà présente (même `## Version <numéro> (`, hors « Version non déterminée ») : un Edit dont l'ancien texte est cette section entière, de son titre jusqu'à la ligne vide qui précède le titre `## Version` suivant (ou la fin du fichier), remplacée par la nouvelle section. Elle n'est jamais dupliquée.
3. Sinon, nouvelle section en tête : un Edit dont l'ancien texte est le titre de la première section `## Version`, remplacé par la nouvelle section, une ligne vide, puis ce même titre. Exception, pour garder la plus récente en tête : si des sections existantes portent un numéro supérieur, insère-la de la même façon avant la première section de numéro inférieur. Sans aucune section, ajoute-la après l'en-tête.

Ne retouche jamais une autre section, même pour corriger une faute ou une mise en forme.

## Fin

Termine par un message court : chemin du livrable, création ou mise à jour, version et plage couvertes, nombre d'entrées par sous-section et de points non déterminés.
