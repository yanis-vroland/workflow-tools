---
name: wf-tests-manquants
description: Liste les tests à écrire en priorité dans un projet JS/TS ou Flutter (fichiers non couverts priorisés, branches non testées, squelettes de tests à copier), écrite dans docs/wf/tests-manquants.md. À utiliser pour sécuriser un projet peu testé avant de le modifier.
---

# wf-tests-manquants

Tu repères les tests qui manquent dans un projet, lancé à sa racine (le répertoire courant, qui peut être un sous-dossier d'un dépôt git), et tu dis lesquels écrire en premier, avec un squelette pour les plus urgents. Le livrable, rédigé en français, s'adresse au développeur ou à l'équipe de développement.

## Règles absolues

- Écris uniquement `docs/wf/tests-manquants.md` (dossier `docs/wf/` créé au besoin), avec l'outil Write. Aucun autre fichier n'est créé ni modifié, en particulier aucun fichier de test : les squelettes restent dans le livrable, le développeur les copie lui-même. Pas de `sed -i`, de `tee`, de `mkdir` ni de redirection `>` vers un fichier (seul `2>/dev/null` est permis).
- L'outil ne lance aucun test, ne mesure pas la couverture et n'installe rien : n'exécute aucune commande `npm`, `pnpm`, `yarn`, `npx`, `node`, `tsx`, `vitest`, `jest`, `playwright`, `flutter`, `fvm`, `dart`, `python`, `pip`, aucune option `--coverage`, aucun script du projet. Un rapport de couverture déjà présent est lu, jamais régénéré.
- Lecture seule sur git : aucune commande qui modifie le dépôt ou sa configuration (add, commit, stash, checkout, reset, fetch, tag, branch…). Aucun accès réseau : n'utilise pas WebFetch.
- Ne lis jamais un fichier `.env*` autre que `.env.example` (ni Read, ni Grep, ni cat) et ne le cite dans aucune commande ; exclus-les de toute recherche : l'outil Grep s'utilise toujours avec `glob: "!**/.env*"` (ou en mode `files_with_matches`), car en mode contenu il afficherait leurs lignes ; en Bash, `--glob '!.env*'` ou `--exclude='.env*'`. Le livrable ne contient aucune valeur d'un fichier d'environnement ni aucun secret, même dans un squelette.
- N'écris dans une commande Bash aucun texte tiré du projet (nom de fichier, de dossier, de fonction, contenu lu) : les commandes ci-dessous s'utilisent telles quelles, et le reste passe par Read, Grep et Glob.
- Ne recopie aucune adresse e-mail de contributeur ni aucune donnée personnelle : seuls des noms de fichiers, de fonctions et des nombres de commits apparaissent.
- Toute affirmation s'appuie sur un fichier lu, dont le chemin est cité. Ce qui ne peut pas être établi est marqué « non déterminé » et listé dans « Points non déterminés ». N'invente jamais un nom de fonction, un comportement, une valeur attendue ni une règle métier.

## Étapes

### 1. Contexte git

```bash
if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = true ] && git rev-parse -q --verify HEAD >/dev/null && [ -n "$(git ls-files -- . | head -1)" ]; then echo "dans git"; git rev-parse --show-prefix; else echo "hors git"; fi
```

- Le projet est dans git si les trois conditions sont réunies : le dossier est dans l'arbre d'un dépôt, ce dépôt a au moins un commit, et il suit des fichiers du dossier courant. Sinon il est « hors git », même sous un dépôt parent : n'utilise alors plus aucune commande git (ni `git log`, ni `git status`).
- Sous-dossier (préfixe non vide) : toute commande git porte sur le seul dossier courant (`-- .`) et l'en-tête mentionne le sous-dossier.

### 2. Inventaire et arrêt si pas de code

Liste les fichiers (noms seulement, relatifs au dossier courant) :

```bash
{ if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = true ] && git rev-parse -q --verify HEAD >/dev/null && [ -n "$(git ls-files -- . | head -1)" ]; then git ls-files --cached --others --exclude-standard -- .; else find . -type f -not -path './.git/*' | sed 's|^\./||'; fi; } \
  | grep -iE '\.(ts|tsx|js|jsx|mjs|cjs|vue|svelte|astro|dart|php|py|rb|go|java|kt|kts|scala|swift|m|mm|c|h|cc|cpp|hpp|cs|rs|ex|exs|lua|pl|r)$' \
  | grep -vE '(^|/)(node_modules|vendor|build|dist|coverage|\.dart_tool|docs/wf)/|\.min\.js$' | sort -u
```

- Répertoire vide (`ls -A` ne liste rien d'autre que `.git` et `.claude`) : réponds « Le répertoire est vide : aucun livrable n'a été écrit. » et arrête-toi, sans rien écrire.
- Aucun fichier source et aucun manifeste (`package.json`, `pubspec.yaml`, `composer.json`, `pyproject.toml`, `requirements.txt`, `Gemfile`, `go.mod`, `Cargo.toml`, `pom.xml`, `build.gradle*`, `*.csproj`) : réponds « Le répertoire ne contient aucun code source : aucun livrable n'a été écrit. » et arrête-toi, sans rien écrire.

### 3. Applications, stacks et périmètre de lecture

- Repère chaque application par son manifeste (`package.json`, `pubspec.yaml`, `pyproject.toml`, `composer.json`…) dans des dossiers distincts : un monorepo en contient plusieurs. Chaque fichier source appartient à l'application dont le manifeste est le plus proche au-dessus de lui.
- Stacks couvertes en v1 : web JavaScript/TypeScript (npm, pnpm, yarn) et Flutter (pub). Toute autre stack (PHP, Python, Ruby…) est signalée « non couverte » dans « Outillage de test », sans analyse : aucune entrée, aucun cas, aucun squelette ne porte sur ses fichiers. Dans un projet mixte, les parties JS/TS et Flutter sont analysées normalement.
- Budget de lecture : environ 300 fichiers source des stacks couvertes. Au-delà, compte les fichiers par dossier parent direct et retire de la lecture les dossiers les plus volumineux, du plus gros au plus petit, jusqu'à repasser sous ce budget : ce sont les dossiers non lus. Ils sont listés dans « Points non déterminés » ; ailleurs, au plus une mention qu'ils n'ont pas été lus. Aucune entrée, aucun cas manquant, aucun squelette, aucune exclusion ni aucun décompte ne porte sur eux.

```bash
<commande de l'étape 2> | sed 's|/[^/]*$||' | sort | uniq -c | sort -rn
```

### 4. En-tête

Date du jour :

```bash
date +%F
```

Commit analysé et état de l'arbre, dans git seulement :

```bash
git rev-parse --short HEAD
git status --porcelain -- . ':(exclude)docs/wf/tests-manquants.md'
```

Une sortie vide de la seconde commande signifie un arbre propre ; sinon, l'en-tête ajoute « modifications non commitées » après le commit. Hors git : « Commit analysé : hors git », sans hash.

### 5. Outillage de test (une sous-section `###` par application)

JS/TS :
- Frameworks : cherche dans `dependencies` et `devDependencies` de `package.json` `vitest`, `jest`, `@playwright/test`, `cypress`, `mocha`, `@testing-library/*`, et les fichiers de configuration (`vitest.config.*`, clé `test` d'un `vite.config.*`, `jest.config.*`, `playwright.config.*`, `cypress.config.*`). Cite chaque framework (Vitest, Jest, Playwright…) avec le fichier qui le déclare.
- Commande de lancement : tirée des `scripts` de `package.json` (`npm test` pour le script `test`, sinon `npm run <script>` ; `pnpm`/`yarn` si leur lockfile est présent), avec le script et ce qu'il lance. Aucun script de test : « commande non déterminée ».
- Nombre de fichiers de test : `*.test.*`, `*.spec.*`, fichiers sous `__tests__/`, `e2e/` ou `tests/`, comptés sur la liste de l'étape 2.
- Aucun framework de test : écris « Aucun framework de test déclaré » et propose le framework le plus courant pour la stack détectée (Vitest pour un projet Vite, Jest sinon), sur une ligne de la forme « Suggestion à valider : <framework> (<raison tirée d'un fichier cité>) », sans le dire installé ni inventer de commande de lancement. Cette application n'aura aucun squelette.

Flutter :
- `flutter_test` (et `integration_test` seulement s'il est déclaré) d'après les `dev_dependencies` de `pubspec.yaml`, chemin cité.
- Commande : `flutter test` (préfixée de `fvm` si le projet fixe sa version par `.fvmrc` ou `.fvm/`).
- Nombre de fichiers `*_test.dart` dans `test/` et dans `integration_test/`, séparément.

Autre stack : une ligne « <stack> (`<manifeste>`) : stack non couverte en v1, non analysée ».

### 6. Couverture actuelle (une sous-section `###` par application)

Fichiers sans logique exécutable, d'abord : déclarations de types seules (`.d.ts`, fichier qui ne contient que des `interface`, `type`, `enum` ou constantes sans fonction), configuration (`*.config.*`, `.eslintrc.*`…), fichiers générés (`*.g.dart`, `*.freezed.dart`, `*.gr.dart`, `*.mocks.dart`, ou fichier dont l'en-tête porte un commentaire de génération : `GENERATED CODE`, `@generated`, `DO NOT EDIT`, `Code generated`). Ils sont exclus de l'analyse, n'apparaissent jamais dans « Tests manquants », et la sous-section donne leur nombre (« Fichiers exclus (sans logique exécutable) : N »), avec leurs chemins.

Rapport de couverture déjà présent : cherche, à la racine de chaque application, `coverage/lcov.info` (produit notamment par `flutter test --coverage`) et `coverage/coverage-summary.json` (Vitest, Jest). Ils sont souvent ignorés par git : cherche-les sur le disque, sans écrire aucun nom de dossier du projet dans la commande.

```bash
find . -path ./.git -prune -o -path '*/node_modules' -prune -o -type f \( -path '*/coverage/lcov.info' -o -path '*/coverage/coverage-summary.json' \) -print \
  | while IFS= read -r f; do printf '%s %s %s\n' "$f" "$(date -r "$f" '+%Y-%m-%d %H:%M')" "$(date -r "$f" +%s)"; done
```

Date du dernier commit, dans git seulement :

```bash
git log -1 --format='%cd %ct' --date=format:'%Y-%m-%d %H:%M' HEAD
```

- Un rapport présent est exploité : cite son chemin, sa date de modification et les chiffres qu'il donne (lignes, branches, par fichier) ; un fichier source absent du rapport est réputé non couvert. Si sa date est antérieure à celle du dernier commit, écris qu'il est antérieur au dernier commit et donc possiblement périmé. Hors git, l'antériorité est « non déterminée ».
- Aucun rapport : applique l'heuristique de `wf-analyse-projet` et précise à chaque fois qu'elle est approximative (ni exécution des tests, ni mesure de couverture). Un fichier source est réputé couvert si un fichier de test l'importe ou porte son nom (`cart.ts` et `cart.test.ts`, `price_utils.dart` et `price_utils_test.dart`) :

```bash
files=$(<commande de l'étape 2>)
tests=$(grep -E '\.(test|spec)\.[jt]sx?$|_test\.dart$|(^|/)(__tests__|test|tests|e2e|integration_test)/' <<<"$files")
while IFS= read -r f; do
  [ -n "$f" ] || continue
  stem=$(basename "${f%.*}")
  esc=$(printf '%s' "$stem" | sed 's/[][\.*^$+?(){}|/]/\\&/g')
  grep -qE "(^|/)${esc}([._](test|spec))?\.[a-z]+$|(^|/)${esc}_test\.dart$" <<<"$tests" && continue
  [ -n "$tests" ] && tr '\n' '\0' <<<"$tests" | xargs -0 grep -qE "(import|from|require\()[^;]*['\"/]${esc}(\.[a-z]+)?['\"]" 2>/dev/null && continue
  printf '%s\n' "$f"
done < <(grep -vxF -e "$tests" <<<"$files")
```

Retire de ce résultat les fichiers exclus, ceux des dossiers non lus et ceux des stacks non couvertes : il reste les fichiers non couverts à analyser.

### 7. Fréquence de modification (dans git seulement)

Même calcul que `wf-analyse-projet`, dans git seulement :

```bash
git log --since="12 months ago" --no-merges --relative --format= --name-only HEAD -- . \
  | grep -v '^$' | while IFS= read -r f; do [ -e "$f" ] && printf '%s\n' "$f"; done | sort | uniq -c | sort -rn
```

Top 10 : les 10 fichiers encore présents les plus modifiés sur les 12 derniers mois, sur la branche courante. Un fichier modifié par un seul commit n'est pas un point chaud : s'il en reste moins de 10, le top est plus court. Hors git, ce critère n'est pas appliqué : aucune entrée n'a la priorité haute à ce titre, aucun nombre de commits n'est donné (« Commits sur 12 mois : non applicable (hors git) »), et « Points non déterminés » le signale.

### 8. Tests manquants

Lis chaque fichier non couvert retenu et crée une entrée :

- Identifiant stable `M1`, `M2`… (préfixe « M », jamais « T », réservé aux tickets de `wf-specs-tickets`).
- Application concernée (ligne « Application : »).
- À tester : les fonctions, classes, composants ou widgets exportés (publics), par leur nom exact dans le code, entre accents graves. En Dart, tout nom qui ne commence pas par `_` est public. Fichier sans export (script, point d'entrée) : nomme la fonction ou l'élément exécuté à son chargement, avec la mention « non exporté ».
- Type de test, exactement l'un de : unitaire (logique pure), composant ou widget (composant d'interface, widget Flutter), intégration (route, contrôleur, accès aux données, service qui appelle l'extérieur), bout en bout (parcours complet, seulement si un outil de bout en bout est déclaré).
- Priorité, à appliquer dans cet ordre :
  1. haute : le fichier est dans le top 10 de l'étape 7 ;
  2. moyenne : sinon, il contient au moins une fonction ou méthode publique avec une branche conditionnelle (`if`, `switch`, opérateur ternaire, levée d'exception par `throw`). Est publique une fonction exportée, une méthode publique d'une classe exportée, ou un gestionnaire enregistré sur un objet exporté (route d'un routeur exporté). Une branche située dans une fonction non exportée, une méthode privée ou une méthode d'une classe privée ne compte pas (en Dart, un nom qui commence par `_` est privé, y compris la classe d'état d'un widget) ;
  3. faible : tous les autres.
- Justification : le critère appliqué, avec le nombre de commits pour la priorité haute, ou la fonction et la branche pour la priorité moyenne.
- Commits sur 12 mois : le nombre de l'étape 7 (0 s'il n'y figure pas).

Tri : par priorité (haute, moyenne, faible), puis par nombre de commits sur 12 mois décroissant, puis par chemin. Aucun fichier non couvert : écris « Aucun fichier source sans test. », sans inventer d'entrée.

### 9. Cas manquants dans le code testé

Pour chaque fichier source couvert (hors dossiers non lus et stacks non couvertes), lis-le avec ses fichiers de test. Pour chaque fonction testée, repère ses branches (cas d'erreur, levée d'exception, `else`, retour anticipé, alternative d'un ternaire, `case` d'un `switch`) et vérifie si au moins une donnée d'entrée des tests existants la déclenche. Si un rapport de couverture le dit (branche ou ligne à 0), appuie-toi dessus.

Une ligne par cas, sous la forme : « `<fonction>` (`<fichier source>` l. <ligne de la branche>) : <branche non déclenchée> ; test existant : `<fichier de test>` ; statut : à vérifier. » Le statut est toujours « à vérifier » : c'est une lecture, pas une mesure. Aucun cas : écris « Aucun cas manquant identifié. »

### 10. Squelettes de tests

Pour chaque entrée de priorité haute dont l'application a un framework de test, un squelette :

- Titre « ### M<n> · à copier dans » suivi du chemin entre accents graves, ce chemin suivant les conventions des tests existants de l'application : à côté du fichier source (`cart.test.ts`), sous `__tests__/`, ou dans `test/` en reprenant l'arborescence de `lib/` pour Flutter. Sans test existant, la convention par défaut du framework.
- Un bloc de code dans le langage et le framework du projet : `describe`/`it` pour Vitest ou Jest, `group`/`test` ou `testWidgets` pour `flutter_test`. Reprends le style d'import des tests existants.
- Un cas par comportement identifié dans le code (chaque branche, chaque cas d'erreur), nommé d'après ce comportement.
- Toute valeur attendue qui n'est pas écrite telle quelle dans le code (donnée métier, contenu d'une liste, montant, date…) est remplacée par le marqueur « à compléter » (`/* à compléter */`, `// à compléter`). Aucune règle métier n'est inventée.
- N'importe aucune bibliothèque absente des dépendances du projet ; si le test en exige une (client HTTP de test, bouchon), signale-le dans un commentaire « à compléter ».

Aucune entrée de priorité haute, ou application sans framework : écris qu'aucun squelette n'est proposé et pourquoi.

### 11. Écriture et relance

- Si `docs/wf/tests-manquants.md` existe, relis-le puis réécris-le en entier, sans second fichier ni section dupliquée : actualise la date et le commit, conserve ce qui reste vrai, corrige le reste.
- Identifiants à la relance, dans cet ordre :
  1. une entrée encore valable (même fichier source, toujours non couvert) garde exactement son identifiant ;
  2. une entrée dont le test a été écrit depuis (le fichier est désormais couvert) est retirée ;
  3. calcule le dernier identifiant attribué : le plus grand entre celui de la ligne « Dernier identifiant attribué » et le plus grand `M<n>` du livrable précédent ;
  4. tout identifiant inférieur ou égal à ce maximum et absent du nouveau livrable est retiré pour toujours : il n'est jamais réattribué, même à un fichier qui semble correspondre ;
  5. les nouvelles entrées reçoivent les identifiants suivants, à partir de ce maximum plus un ;
  6. la ligne « Dernier identifiant attribué » porte ensuite le plus grand identifiant jamais attribué (« aucun » si aucune entrée n'a jamais été créée).
- Première exécution : les entrées sont numérotées `M1`, `M2`… dans l'ordre de tri de l'étape 8.
- Respecte le modèle ci-dessous : les sept sections en titres `##`, dans cet ordre, une seule fois chacune ; les entrées et sous-sections en `###`.
- Termine par un message court : chemin du livrable, nombre d'entrées par priorité, nombre de cas à vérifier, nombre de points non déterminés.

## Modèle du livrable

Les éléments entre chevrons sont à remplacer par les valeurs du projet analysé. Hors dépôt, l'en-tête porte « Commit analysé : hors git », sans aucun hash. Pour Flutter, « Outillage de test » cite flutter_test et integration_test d'après `pubspec.yaml`, `flutter test` et le nombre de `*_test.dart` dans `test/` et `integration_test/` ; une stack non couverte tient en une ligne « non couverte » ; sans framework, « Aucun framework de test déclaré » puis la suggestion à valider.

```markdown
# Tests à écrire en priorité

Outil : wf-tests-manquants · Date : AAAA-MM-JJ · Commit analysé : <hash court>[ · modifications non commitées][ · Sous-dossier : `<préfixe>`]
Dernier identifiant attribué : M<n>

## Synthèse

En quelques phrases : applications analysées, état des tests, nombre d'entrées par priorité, cas à vérifier.

## Outillage de test

### <Application> (`<dossier>`)

- Framework : <nom> (`<fichier qui le déclare>`)
- Commande : `<commande>` (script `<nom>` de `package.json`)
- Fichiers de test : <N>

## Couverture actuelle

### <Application> (`<dossier>`)

- Source : rapport `<chemin>` (modifié le AAAA-MM-JJ HH:MM[, antérieur au dernier commit du AAAA-MM-JJ]) — ou heuristique approximative (un fichier est réputé couvert si un test l'importe ou porte son nom ; ni exécution ni mesure).
- Fichiers source analysés : <N> · couverts : <N> · non couverts : <N>
- Fichiers exclus (sans logique exécutable) : <N> (`<chemin>`…)

## Tests manquants

### M1 · `<chemin du fichier source>`

- Application : <application>
- À tester : `<nom exporté>`, `<nom exporté>`
- Type de test : <unitaire | composant ou widget | intégration | bout en bout>
- Priorité : <haute | moyenne | faible>
- Justification : <critère appliqué>
- Commits sur 12 mois : <N>

## Cas manquants dans le code testé

- `<fonction>` (`<fichier source>` l. <n>) : <branche non déclenchée> ; test existant : `<fichier de test>` ; statut : à vérifier.

## Squelettes de tests

### M1 · à copier dans `<chemin du fichier de test>`

(bloc de code du squelette, dans le langage et le framework de l'application, valeurs inconnues marquées « à compléter »)

## Points non déterminés

- (hors git : critère de fréquence de modification non appliqué ; dossiers non lus ; stacks non couvertes ; commande de test non déterminée ; limites de l'heuristique…)
```
