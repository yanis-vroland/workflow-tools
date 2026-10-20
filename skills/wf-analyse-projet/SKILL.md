---
name: wf-analyse-projet
description: Diagnostic d'un projet existant (stack, dépendances obsolètes, architecture, activité git, tests, sécurité visible, dette, effort de reprise), écrit dans docs/wf/analyse-projet.md. À utiliser pour reprendre, auditer ou évaluer un projet avant de s'engager ou de chiffrer.
---

# wf-analyse-projet

Tu produis un diagnostic interne d'un projet existant, lancé à sa racine (le répertoire courant, qui peut être un sous-dossier d'un dépôt git). Le livrable est rédigé en français, pour le freelance (pas pour le client).

## Règles absolues

- Écris uniquement `docs/wf/analyse-projet.md` (dossier `docs/wf/` créé au besoin), avec l'outil Write. Aucun autre fichier n'est créé ni modifié, y compris temporaire : pas de `sed -i`, de `tee` ni de redirection `>` vers un fichier (seul `2>/dev/null` est permis).
- Lecture seule : aucune commande git qui modifie le dépôt ou sa configuration (add, commit, stash, checkout, reset, fetch, tag, branch -D, config…), aucune installation (`npm install`, `yarn`, `pnpm add`, `pub get`…), aucune exécution du projet, de ses tests ou de ses scripts (`node`, `tsx`, `npx`, `./script`…).
- N'utilise pas WebFetch : les registres s'interrogent par Bash (étape 4), seulement avec des noms de paquets validés.
- Ne lis jamais un fichier `.env*` autre que `.env.example` (ni Read, ni Grep, ni cat) et ne le cite dans aucune commande ; exclus-les explicitement de toute recherche (`--glob '!.env*'`). Le livrable ne contient aucune de leurs valeurs ni aucun secret.
- Ne recopie aucune adresse e-mail de contributeur : n'affiche que les noms (`%an`, `git shortlog -sn`).
- Toute affirmation s'appuie sur un fichier lu, dont le chemin est cité. Ce qui ne peut pas être établi est marqué « non déterminé », listé dans « Points non déterminés » et affirmé nulle part ailleurs. N'invente jamais une version, une date ou un hébergeur : ne nomme aucun fournisseur d'hébergement ou de cloud qui n'est pas cité dans un fichier du projet.

## Étapes

### 1. Contexte git

```bash
if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = true ] && git rev-parse -q --verify HEAD >/dev/null && [ -n "$(git ls-files -- . | head -1)" ]; then echo "dans git"; git rev-parse --show-prefix; else echo "hors git"; fi
```

- Le projet est dans git si les trois conditions sont réunies : le dossier est dans l'arbre d'un dépôt, ce dépôt a au moins un commit, et il suit des fichiers du dossier courant. La racine du dépôt comme un sous-dossier suivi conviennent. Sinon il est « hors git », même sous un dépôt parent (dépôt sans commit, ou qui ne suit pas ce dossier, comme un dossier personnel versionné) : n'utilise alors aucune commande git, ni pour l'en-tête ni pour l'activité.
- Préfixe affiché (dans git) : vide pour la racine du dépôt, sinon le sous-dossier analysé.
- Sous-dossier (préfixe non vide) : le commit analysé reste celui du dépôt, l'en-tête mentionne le sous-dossier, et toute commande git porte sur le seul dossier courant (`-- .`) : fichiers, historique, contributeurs. Ne cite rien du reste du dépôt.

### 2. Inventaire et arrêt si pas de code

Liste les fichiers source (noms seulement, relatifs au dossier courant) :

```bash
{ if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = true ] && git rev-parse -q --verify HEAD >/dev/null && [ -n "$(git ls-files -- . | head -1)" ]; then git ls-files --cached --others --exclude-standard -- .; else find . -type f -not -path './.git/*' | sed 's|^\./||'; fi; } \
  | grep -iE '\.(ts|tsx|js|jsx|mjs|cjs|vue|svelte|astro|html?|css|scss|sass|less|dart|php|py|rb|go|java|kt|kts|scala|groovy|swift|m|mm|c|h|cc|cpp|hpp|cs|fs|rs|ex|exs|erl|clj|lua|pl|r|sh|bash|sql)$' \
  | grep -vE '(^|/)(node_modules|vendor|build|dist|\.dart_tool|docs/wf)/|(^|/)\.env|\.d\.ts$|\.g\.dart$|\.min\.(js|css)$' | sort -u
```

- Répertoire vide (`ls -A` ne liste rien d'autre que `.git` et `.claude`) : réponds « Le répertoire est vide : aucun livrable n'a été écrit. » et arrête-toi.
- Aucun fichier source et aucun manifeste (`package.json`, `pubspec.yaml`, `composer.json`, `pyproject.toml`, `requirements.txt`, `Gemfile`, `go.mod`, `Cargo.toml`, `pom.xml`, `build.gradle*`, `*.csproj`, `mix.exs`, `build.sbt`, `CMakeLists.txt`, `Makefile`) : réponds « Le répertoire ne contient aucun code source : aucun livrable n'a été écrit. » et arrête-toi.
- Un manifeste sans fichier source reconnu : le projet contient du code dans une extension non listée ; poursuis et signale-le dans « Points non déterminés ».

Stacks couvertes : web JavaScript/TypeScript (npm, pnpm, yarn) et Flutter (pub). Une autre stack est détectée et signalée « non couverte », sans analyse approfondie. Repère chaque application (manifeste `package.json`, `pubspec.yaml`… dans des dossiers distincts) : un monorepo en contient plusieurs.

### 3. En-tête, volume et périmètre de lecture

- Commit analysé : `git rev-parse --short HEAD`.
- Arbre propre : `git status --porcelain -- . ':(exclude)docs/wf/analyse-projet.md'` vide. Sinon, l'en-tête ajoute « modifications non commitées » après le commit.
- Date du jour : `date +%F`.

Budget de lecture : environ 300 fichiers source, ordre de grandeur de ce qu'une session parcourt en gardant du contexte pour la rédaction. Au-delà, compte les fichiers par dossier parent direct (`<commande de l'étape 2> | sed 's|/[^/]*$||' | sort | uniq -c | sort -rn`) et retire de la lecture les dossiers les plus volumineux, du plus gros au plus petit, jusqu'à repasser sous ce budget : ce sont les dossiers non lus. Ils sont listés dans « Points non déterminés », et nulle part ailleurs : aucune conclusion ne porte sur eux (couverture, sécurité, dette, architecture), ni risque (même « non analysé »), ni niveau, ni estimation d'effort. Seule exception : un fichier d'un dossier non lu qui figure dans le top 10 de l'étape 5 est lu à ce titre, et lui seul peut alors fonder une conclusion.

Lis ensuite les manifestes, lockfiles, configurations (CI, Docker, `.env.example`), points d'entrée, routes, services et tests.

### 4. Dépendances

- Version installée : celle du lockfile (`package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, `pubspec.lock`), à défaut celle du manifeste en le précisant.
- Dernière version publiée des dépendances directes, en une commande par écosystème. Avant de l'écrire dans la commande, vérifie chaque nom : npm `^(@[a-z0-9._-]+/)?[a-z0-9._-]+$`, pub `^[a-z0-9_]+$`. Un nom non conforme n'est jamais écrit dans une commande : signale-le comme non vérifié. Écris chaque nom entre apostrophes simples ; le `/` d'un paquet à portée (`@scope/nom`) est encodé en `%2F`.

```bash
for p in '<paquet>' '<@scope/paquet>'; do
  [[ $p =~ ^(@[a-z0-9._-]+/)?[a-z0-9._-]+$ ]] || { echo "npm $p nom invalide, ignoré"; continue; }
  out=$(curl -sf --max-time 10 -w '\n%{http_code}' "https://registry.npmjs.org/${p/\//%2F}/latest"); rc=$?; code=${out##*$'\n'}
  case "$rc:$code" in
    0:*) echo "npm $p $(grep -o '"version":"[^"]*"' <<<"$out" | head -1)" ;;
    22:404) echo "npm $p introuvable (404)" ;;
    *) echo "npm $p injoignable (curl $rc)" ;;
  esac
done
for p in '<paquet>'; do
  [[ $p =~ ^[a-z0-9_]+$ ]] || { echo "pub $p nom invalide, ignoré"; continue; }
  out=$(curl -sf --max-time 10 -w '\n%{http_code}' "https://pub.dev/api/packages/$p"); rc=$?; code=${out##*$'\n'}
  case "$rc:$code" in
    0:*) echo "pub $p $(grep -o '"latest":{"version":"[^"]*"' <<<"$out" | head -1)" ;;
    22:404) echo "pub $p introuvable (404)" ;;
    *) echo "pub $p injoignable (curl $rc)" ;;
  esac
done
```

- Cite chaque dépendance en retard d'au moins une version majeure sur une ligne : nom, version installée, dernière version publiée, registre interrogé.
- Paquet introuvable (404) : le registre répond mais ne le connaît pas (paquet privé, renommé ou retiré) ; dis-le, sans le compter comme injoignable.
- Registre injoignable : garde les versions du lockfile, écris « dernière version : non déterminée », et signale dans « Points non déterminés » le registre injoignable et le repli sur le lockfile. Ne complète jamais une version publiée de mémoire.

### 5. Activité du dépôt (git seulement)

```bash
git log --reverse --format=%ad --date=short HEAD -- . | head -1   # premier commit
git log -1 --format=%ad --date=short HEAD -- .                    # dernier commit
git shortlog -sn HEAD -- . | wc -l                                # contributeurs
git rev-parse --is-shallow-repository                             # historique tronqué
git log --since="12 months ago" --no-merges --relative --format= --name-only HEAD -- . \
  | grep -v '^$' | while IFS= read -r f; do [ -e "$f" ] && printf '%s\n' "$f"; done | sort | uniq -c | sort -rn
```

- Top 10 : les 10 fichiers encore présents (les fichiers supprimés sont filtrés) les plus modifiés sur les 12 derniers mois, avec leur nombre de commits, sur la branche courante (`HEAD`), jamais sur les autres branches. Un fichier modifié par un seul commit n'est pas un point chaud : s'il en reste moins de 10, dis-le.
- Clone superficiel (`true`) : la date du premier commit est « non déterminée » ; indique la période réellement couverte (« historique disponible du AAAA-MM-JJ au AAAA-MM-JJ ») et signale l'historique tronqué dans « Points non déterminés ».
- Hors git : la section indique « non applicable ».

### 6. Qualité et tests

Un fichier source est réputé couvert si un fichier de test l'importe ou porte son nom (`cart.ts` et `cart.test.ts`, `price_utils.dart` et `price_utils_test.dart`). Liste les fichiers non couverts (chemins complets), hors dossiers non lus, hors balisage, styles, SQL et scripts shell :

```bash
files=$(<commande de l'étape 2> | grep -viE '\.(html?|css|scss|sass|less|sql|sh|bash)$')
tests=$(grep -E '\.(test|spec)\.[jt]sx?$|_test\.dart$|(^|/)(__tests__|test|tests)/' <<<"$files")
while IFS= read -r f; do
  [ -n "$f" ] || continue
  stem=$(basename -- "${f%.*}")
  re=$(printf '%s' "$stem" | sed 's/[][\.^$*+?(){}|/]/\\&/g')
  grep -qE -e "(^|/)${re}([._](test|spec))?\.[a-z]+$|(^|/)${re}_test\.dart$" <<<"$tests" && continue
  [ -n "$tests" ] && tr '\n' '\0' <<<"$tests" | xargs -0 grep -qE -e "(import|from|require\()[^;]*['\"/]${re}(\.[a-z]+)?['\"]" -- 2>/dev/null && continue
  printf '%s\n' "$f"
done < <(grep -vxF -e "$tests" <<<"$files")
```

Le nom de chaque fichier est échappé avant la recherche (parenthèses, points, tiret initial pris littéralement) ; les fichiers d'environnement sont exclus dès l'inventaire de l'étape 2 et ne sont jamais lus ici.

Limite : la recherche se fait ligne à ligne. Un import réparti sur plusieurs lignes (`import {` … `} from '…'`) est vu par sa ligne `from` ; un chemin construit dynamiquement ou un alias qui ne finit pas par le nom du fichier ne l'est pas. Précise à chaque fois que cette heuristique est approximative (ni exécution des tests, ni mesure de couverture). Relève aussi la présence de lint, de CI, de TODO/FIXME.

### 7. Sécurité, dette, effort

- Sécurité : seulement les signaux visibles (requêtes concaténées, secrets en dur, authentification faible, dépendances très anciennes), chemins cités. Pas d'audit approfondi.
- Dette et risques : chaque risque a un niveau, exactement « élevé », « moyen » ou « faible », et cite au moins un fichier. Tout fichier à la fois dans le top 10 et non couvert y figure obligatoirement.
- Effort de reprise : faible, moyen ou élevé, justifié en renvoyant aux risques listés. Aucun chiffrage : aucun nombre de jours, semaines, heures ou mois-homme (c'est `wf-chiffrage`).

### 8. Écriture

- Si `docs/wf/analyse-projet.md` existe, relis-le puis réécris-le en entier : conserve ce qui reste vrai, corrige le reste, actualise la date et le commit de l'en-tête. Jamais de second fichier ni de section dupliquée.
- Respecte le modèle ci-dessous : les neuf sections en titres `##`, dans cet ordre, une seule fois chacune. Les sous-sections (`###`) ne reprennent pas un nom de section.
- Termine par un message court : chemin du livrable, effort de reprise, nombre de points non déterminés.

## Modèle du livrable

Les éléments entre chevrons sont à remplacer par les valeurs du projet analysé.

```markdown
# Analyse du projet

Outil : wf-analyse-projet · Date : AAAA-MM-JJ · Commit analysé : <hash court>[ · modifications non commitées][ · Sous-dossier : `<préfixe>`]

(hors dépôt : « Commit analysé : hors git », sans aucun hash)

## Synthèse

Vue globale en quelques phrases : nature du projet, chaque application (web, mobile…), état général, principaux risques.

## Stack et dépendances

Par application : langages, frameworks, gestionnaire de paquets, lockfile.
- `<paquet>` : installée <x.y.z> (`<lockfile>`), dernière publiée <x.y.z> (registre <registre>), retard majeur.

## Architecture

### <Application> (`<dossier>`)

Organisation, points d'entrée, couches, chemins cités.

### <Autre application> (`<dossier>`)

(une sous-section par application en monorepo)

## Activité du dépôt

- Premier commit : AAAA-MM-JJ · dernier commit : AAAA-MM-JJ · N contributeurs.
- Fichiers les plus modifiés sur 12 mois : `<chemin>` (N commits)…

(hors git : « non applicable »)

## Qualité et tests

Tests présents, outillage. Fichiers source non couverts : `<chemin>`…
Heuristique approximative : un fichier est réputé couvert si un test l'importe ou porte son nom.

## Sécurité

Signaux visibles, avec chemins.

## Dette et risques

- **élevé** : description (`<chemin>`).
- **moyen** : description (`<chemin>`).
- **faible** : description (`<chemin>`).

## Effort de reprise

Effort **moyen** : justification par les risques listés ci-dessus.

## Points non déterminés

- Hébergement de production : non déterminé.
- (registre injoignable et repli sur le lockfile, historique tronqué, dossiers non lus, stack non couverte…)
```
