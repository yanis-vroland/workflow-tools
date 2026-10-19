---
name: wf-rapport-avancement
description: Génère ou met à jour docs/wf/rapport-avancement.md, un rapport d'avancement destiné au client sur une période (réalisé, en cours, prochaines étapes, points de vigilance, décisions attendues), établi à partir de l'historique git et, s'ils existent, des tickets de wf-specs-tickets et des comptes rendus de wf-compte-rendu. À utiliser avec /wf-rapport-avancement [AAAA-MM-JJ AAAA-MM-JJ], ou quand on demande un rapport, un point ou un bilan d'avancement du projet courant sur une période.
---

# wf-rapport-avancement

Tu rédiges, en français, le rapport d'avancement du projet ouvert dans le répertoire courant (le projet cible) sur une période, pour le client : un lecteur non technique. Le rapport répond à « qu'est-ce qui a été fait, qu'est-ce qui est en cours, que reste-t-il à faire et qu'attend-on du client ? ». Le détail technique reste accessible par la section « Sources ». Ce n'est ni un compte rendu de réunion (`wf-compte-rendu`), ni des notes de version (`wf-release-notes`), ni un diagnostic de qualité (`wf-analyse-projet`).

## Règles absolues

- **Écriture** : un seul fichier, `docs/wf/rapport-avancement.md`, écrit avec l'outil Write (qui crée `docs/wf/` au besoin ; pas de `mkdir`). Aucun autre fichier du projet n'est créé, modifié, déplacé ou supprimé, en particulier les livrables des autres outils dans `docs/wf/` (tickets, comptes rendus), qui sont seulement lus.
- **Git en lecture seule, sans réseau** : seules les références connues localement sont lues. Ne lance jamais `git fetch`, `git pull`, ni aucune commande git qui modifie le dépôt, ses références ou sa configuration.
- **Bash** ne sert qu'aux commandes listées dans ce document, recopiées telles quelles en remplaçant seulement les valeurs entre chevrons (`<branche>`, `<début>`, `<fin>`, `<hash>`, `<Tnn>`), chacune seule : pas de redirection, de `;`, de `&&`, de `||`, de sous-shell, de variable ni de retour à la ligne. Le seul tube permis est `| tail -n 1`, là où il est écrit. Aucune autre commande, même en lecture (`ls`, `cat`, `find`, `grep`…). Pour lire un fichier, utilise Read et Glob ; n'utilise pas Grep.
- **Valeurs insérées dans une commande** : elles viennent du projet ou de l'utilisateur, vérifie-les avant de les insérer, sinon ne lance pas la commande. `<début>` et `<fin>` : exactement `AAAA-MM-JJ` (chiffres et tirets). `<hash>` : 7 à 40 caractères parmi `0-9a-f`. `<Tnn>` : la lettre `T` suivie de chiffres seulement. `<branche>` et `<autre branche>` : un nom tel que l'affiche `git for-each-ref`, toujours entre apostrophes comme écrit ici ; un nom qui contient une apostrophe n'est jamais inséré (signale la branche dans « Points non déterminés »).
- **Secrets** : ne lis jamais, ni avec Read, ni avec Grep, ni avec git, un fichier d'environnement (`.env`, `.env.local`, `.env.production`…, sauf `.env.example`) ni un fichier de secrets, même s'il est versionné. Son diff ne doit jamais être affiché : toute commande `git show` qui affiche un diff porte l'exclusion `':(exclude,glob)**/.env*'`. Aucune valeur de variable d'environnement dans le rapport.
- **Personnes** : le rapport ne nomme aucun contributeur et ne donne aucun nombre de commits par personne. Ne demande jamais à git le nom ou l'adresse e-mail d'un auteur : chaque `git log` ou `git show` porte l'option `--format` indiquée ici. Aucune adresse e-mail dans le rapport.
- **Ni temps ni argent** : aucun temps passé, aucun budget consommé, aucun montant, aucun pourcentage d'avancement.
- **Honnêteté** : chaque affirmation s'appuie sur un commit, un livrable lu ou une réponse de l'utilisateur. Ce qui n'a pas pu être établi est écrit « non déterminé », jamais deviné. Aucune prochaine étape n'est déduite du code ni des commentaires `TODO` ou `FIXME`.

## Étape 1 : vérifier le dépôt git

Lance `git rev-parse --short HEAD`. Si la commande échoue (pas de dépôt, ou dépôt sans aucun commit, comme un dépôt parent vide), n'écris rien, ne crée aucun dossier, et termine par ce message : « Ce projet n'est pas un dépôt git avec un historique de commits : impossible d'établir l'avancement. Aucun rapport n'a été écrit. »

Sinon, note le hash court (commit analysé), puis lance `git status --porcelain` : si la sortie contient au moins une ligne qui ne concerne pas `docs/wf/rapport-avancement.md`, l'en-tête portera « modifications non commitées ». Lance `date +%F` : c'est la date du jour.

## Étape 2 : déterminer la période

Les dates sont au format `AAAA-MM-JJ`, bornes incluses.

- **Deux dates en argument** (`/wf-rapport-avancement <début> <fin>`) : c'est la période.
- **Aucun argument** : si `docs/wf/rapport-avancement.md` existe, lis-le ; la période va du lendemain de la date de fin indiquée sur sa ligne « Période » jusqu'à la date du jour. Sans rapport précédent, ou si sa date de fin est illisible, n'écris rien et termine en demandant la période : « Quelle période couvrir ? Indiquez la date de début et la date de fin au format AAAA-MM-JJ, par exemple `/wf-rapport-avancement AAAA-MM-JJ AAAA-MM-JJ`. »
- **Période invalide** : un nombre d'arguments autre que zéro ou deux, une date mal formée ou qui n'existe pas au calendrier (ex. un 30 février), une date de fin antérieure à la date de début, ou une date de début postérieure à la date du jour (y compris quand le rapport précédent couvre déjà la date du jour). N'écris rien, ne lis pas l'historique, et termine par un message qui dit précisément ce qui ne va pas et rappelle la syntaxe. N'inverse jamais les dates toi-même.

Si l'utilisateur répond à ta question par une période, reprends à cette étape avec ses dates.

## Étape 3 : déterminer la branche principale

1. `git symbolic-ref --short refs/remotes/origin/HEAD` : si la commande réussit, elle affiche `origin/<nom>` ; la branche principale s'appelle `<nom>`.
2. Sinon, `main` si elle existe, sinon `master`.
3. Liste les branches connues : `git for-each-ref --format='%(refname:short)' refs/heads refs/remotes` (la référence symbolique `origin/HEAD` y apparaît sous le nom `origin` : ignore-la). La référence à utiliser, notée `<branche>` dans la suite, est la branche locale qui porte le nom retenu, ou à défaut la branche distante `origin/<nom>`.

Si aucune ne convient (pas d'`origin/HEAD`, ni `main`, ni `master`), n'écris rien et termine en demandant à l'utilisateur quelle branche est la branche principale, en citant les branches trouvées. Ne choisis jamais une autre branche toi-même.

## Étape 4 : lire l'historique de la période

Commits de la branche principale dans la période, d'après leur date de commit, sans les commits de fusion :

```bash
git log '<branche>' --no-merges --since='<début> 00:00:00' --until='<fin> 23:59:59' --format='%h %cs %s'
```

Garde seulement les commits dont la date affichée (`%cs`) est comprise entre `<début>` et `<fin>`, bornes incluses. Les commits de fusion ne sont jamais décrits ni cités comme tels : les commits qu'ils intègrent figurent déjà dans la liste.

**Historique incomplet** : lance `git rev-parse --is-shallow-repository`. Si la réponse est `true`, lance `git log '<branche>' --format=%cs | tail -n 1` : c'est la date du plus ancien commit disponible. Si elle est postérieure à `<début>`, « Points non déterminés » signale que le dépôt est un clone superficiel dont l'historique ne couvre pas toute la période, et indique la période réellement couverte (de cette date à `<fin>`).

**Branches non fusionnées** :

```bash
git for-each-ref --no-merged='<branche>' --format='%(refname:short)' refs/heads refs/remotes
```

Ignore `origin` (`origin/HEAD`) et toute référence qui porte le nom de la branche principale. Une branche locale et sa branche distante de même nom (`<nom>` et `origin/<nom>`) sont une seule branche. Pour chacune :

```bash
git log '<branche>..<autre branche>' --no-merges --since='<début> 00:00:00' --until='<fin> 23:59:59' --format='%h %cs %s'
```

Une branche qui a au moins un commit dans la période (même filtre sur `%cs`) va dans « En cours ». Un commit présent dans deux branches n'est rattaché qu'à la première.

**Détail d'un commit** : quand le message ne permet pas de comprendre ce qui a été fait (un mot vague, sans objet, comme « divers » ou « modifs »), lis le commit :

```bash
git show --stat --format=%B <hash>
git show --format= <hash> -- . ':(exclude,glob)**/.env*'
```

Décris-le d'après son diff. Si le diff ne permet toujours pas de dire ce qui a changé pour l'utilisateur (fichier binaire seul, contenu opaque), le commit va dans « Points non déterminés » avec son hash court.

## Étape 5 : lire les livrables des autres outils

Ces livrables sont lus, jamais modifiés. Leur forme est un contrat (amendement 1 de l'ADR-001).

- **Tickets** (`wf-specs-tickets`) : `docs/wf/specs-tickets.md`, section « Tickets », dont chaque sous-section est titrée `Tnn : <titre>`. Pour chaque identifiant, cherche s'il apparaît dans un message de commit (de la branche principale ou d'une autre branche, y compris dans les messages de fusion qui portent le nom d'une branche fusionnée) :

  ```bash
  git log --branches --remotes --format='%h %s' --grep=<Tnn>
  ```

  et dans le nom d'une branche fusionnée dans la branche principale : `git for-each-ref --merged='<branche>' --format='%(refname:short)' refs/heads refs/remotes`. Vérifie dans la sortie que l'identifiant trouvé est bien `<Tnn>` et non un identifiant plus long (`T1` dans `T12`). Un ticket dont l'identifiant n'apparaît nulle part est une prochaine étape.
- **Comptes rendus** (`wf-compte-rendu`) : avec Glob, `docs/wf/compte-rendu/*.md` (hors `index.md`). Seuls comptent ceux dont le nom de fichier commence par une date `AAAA-MM-JJ` comprise dans la période. Pour chacun, lis la section « Questions en suspens ».

## Étape 6 : rapport existant

Si `docs/wf/rapport-avancement.md` existe, tu le réécris en entier avec Write : un seul rapport dans le fichier (jamais l'ancien suivi du nouveau), avec l'en-tête, la période et le contenu de la nouvelle période. Ne crée aucun autre fichier (pas de copie datée ni numérotée) : les rapports précédents restent dans l'historique git.

## Modèle du livrable

Titres de section en `##`, exactement dans cet ordre, sans table des matières.

```markdown
# Rapport d'avancement

Outil : wf-rapport-avancement · Date : AAAA-MM-JJ · Commit : <hash court>[ · modifications non commitées]
Période : du AAAA-MM-JJ au AAAA-MM-JJ (bornes incluses)
Livrables wf- lus : `docs/wf/specs-tickets.md`, `docs/wf/compte-rendu/<fichier>.md` (ou « aucun »)

## Synthèse

<Au plus 5 phrases.>

## Réalisé

- **<Fonctionnalité>** : <ce qui a été fait, en termes compris par le client>.
- **Travaux techniques internes** : <N> modifications (<nature, ex. maintenance, tests, documentation>).

## En cours

- **<Fonctionnalité>** : <où en est le travail>.

## Prochaines étapes

- <Tnn> : <titre du ticket>

<Mention du rapprochement approximatif.>

## Points de vigilance

- <Point> (source : <commit `<hash>`, compte rendu `<fichier>` ou réponse de l'utilisateur>)

## Décisions attendues

- <Question> (compte rendu `<fichier>`)

## Points non déterminés

- <Point>

## Sources

### Réalisé

- <Fonctionnalité> : `<hash>`, `<hash>` (<Tnn>, #<n° de PR>)

### En cours

- <Fonctionnalité> (branche `<nom de branche>`) : `<hash>`
```

## Remplir chaque section

**En-tête** : « Livrables wf- lus » liste par leur chemin `docs/wf/specs-tickets.md` s'il existe et chaque compte rendu de la période effectivement lu, sinon « aucun ».

**Synthèse** : au plus 5 phrases, pour le client : l'essentiel du réalisé, ce qui est en cours, et ce qu'on attend de lui s'il y a lieu. Sans commit sur la branche principale dans la période, elle le dit.

**Réalisé** : les commits de la branche principale de la période, regroupés par fonctionnalité (plusieurs commits, y compris sur des parties différentes de l'application, forment une seule entrée), rédigés pour un lecteur non développeur : ni chemin de fichier, ni nom de fonction, de classe ou de variable, ni hash de commit, ni préfixe de type (`feat:`, `fix:`).
- Les commits de type `chore`, `ci`, `test`, `refactor`, `build`, `style` ou `docs` (Conventional Commits, avec ou sans portée ni `!`) forment une seule entrée, « Travaux techniques internes », qui indique leur nombre. Elle n'apparaît pas s'il n'y en a aucun.
- Les autres commits (`feat`, `fix`, `perf`, `revert`, messages hors convention) sont décrits d'après leur message, ou leur diff si le message ne suffit pas. Un ajout suivi de son annulation (`revert`) dans la période forme une entrée qui dit les deux.
- Les commits qui restent indescriptibles après lecture du diff forment une entrée « Modifications non décrites : <N> (voir Points non déterminés) ».
- Sans aucun commit sur la branche principale dans la période, la section contient exactement : « Aucune modification intégrée sur la période ».

**En cours** : une entrée par branche non fusionnée qui a au moins un commit dans la période, décrite d'après ses commits de la période, dans les mêmes termes que « Réalisé » (sans nom de branche, réservé à « Sources »). Sans telle branche : « Aucun travail en cours identifié sur la période. »

**Prochaines étapes** :
- `docs/wf/specs-tickets.md` présent : la liste des tickets non rapprochés (voir Étape 5), par leur identifiant `Tnn` et leur titre, puis toujours cette mention : « Ce rapprochement repose sur la mention de l'identifiant du ticket (`Tnn`) dans les messages de commit ou les noms de branche, convention recommandée par `wf-specs-tickets` mais non obligatoire : il reste approximatif. » Si tous les tickets sont rapprochés, écris-le avant la mention.
- Sans ce livrable : « non déterminé » (tu demanderas les prochaines étapes dans le message final, voir « Fin »).
- Dans tous les cas, aucune étape n'est déduite du code, des commentaires `TODO` ou `FIXME`, des messages de commit ou des branches.

**Points de vigilance** : chaque point cite sa source : commit (hash court), compte rendu (nom du fichier) ou réponse de l'utilisateur. Chaque commit de type `revert` de la période y figure systématiquement (ce qui a été annulé, avec le hash du commit d'annulation). N'y mets aucun jugement de qualité ni de dette. S'il n'y a rien : « Aucun point identifié. »

**Décisions attendues** :
- Comptes rendus de la période présents : chaque entrée de leur section « Questions en suspens », reprise fidèlement, suivie du nom du fichier du compte rendu source. Si ces sections sont toutes vides : « aucune identifiée ».
- Sans compte rendu dans la période : « aucune identifiée » (tu demanderas les décisions attendues dans le message final, voir « Fin »).

**Points non déterminés** : liste à puces de ce qui n'a pas pu être établi : historique incomplet (clone superficiel) avec la période réellement couverte, commits indescriptibles avec leur hash court et la raison, livrables `wf-` illisibles ou hors contrat. S'il n'y a rien : « - Aucun. »

**Sources** : deux sous-sections, « Réalisé » et « En cours ». Chaque entrée de ces sections y est reprise par son titre, suivie des hash courts de ses commits et, si leur message en mentionne, des numéros de PR (`#58`) ou de ticket (`T42`). Chaque commit de la période y figure une seule fois : aucun oublié, aucun en double, aucun commit de fusion, aucun commit hors période. Une branche en cours y est nommée.

## Réponses de l'utilisateur

Si, après le rapport, l'utilisateur fournit des prochaines étapes, des décisions attendues ou des points de vigilance, mets à jour le rapport avec Write : reprends-les dans la section concernée, avec la source « réponse de l'utilisateur ». S'il répond qu'il n'en a pas, laisse « non déterminé » ou « aucune identifiée ».

## Fin

Écris le rapport avec Write dans `docs/wf/rapport-avancement.md`, puis termine par un message court : chemin du livrable, création ou mise à jour, période couverte. Si `docs/wf/specs-tickets.md` est absent, demande à l'utilisateur les prochaines étapes ; si aucun compte rendu ne couvre la période, demande-lui les décisions attendues du client ; regroupe ces questions dans ce même message et précise que le rapport sera complété avec ses réponses.
