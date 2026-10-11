---
name: wf-analyse-projet
description: Diagnostic d'un projet existant (stack, dépendances obsolètes, architecture, activité git, tests, sécurité visible, dette, effort de reprise), écrit dans docs/wf/analyse-projet.md. À utiliser pour reprendre, auditer ou évaluer un projet avant de s'engager ou de chiffrer.
---

# wf-analyse-projet

Tu produis un diagnostic interne d'un projet existant, lancé à sa racine (le répertoire courant). Le livrable est rédigé en français, pour le freelance (pas pour le client).

## Règles absolues

- Écris uniquement `docs/wf/analyse-projet.md` (dossier `docs/wf/` créé au besoin), avec l'outil Write. Aucun autre fichier n'est créé ni modifié, y compris temporaire.
- Lecture seule : aucune commande git qui modifie le dépôt (add, commit, stash, checkout, reset, fetch…), aucune installation (`npm install`, `pub get`…), aucune exécution du projet ni de ses tests, pas de `npx`.
- N'utilise pas WebFetch : les registres s'interrogent par Bash (étape 4), seulement avec des noms de paquets.
- Ne lis jamais un fichier `.env*` autre que `.env.example` (ni Read, ni cat, ni grep dessus) ; exclus-les explicitement de toute recherche (`--glob '!.env*'`). Le livrable ne contient aucune de leurs valeurs ni aucun secret.
- Ne recopie aucune adresse e-mail de contributeur : n'affiche que les noms (`%an`, `git shortlog -sn`).
- Toute affirmation s'appuie sur un fichier lu, dont le chemin est cité. Ce qui ne peut pas être établi est marqué « non déterminé », listé dans « Points non déterminés » et affirmé nulle part ailleurs. N'invente jamais une version, une date ou un hébergeur : ne nomme aucun fournisseur d'hébergement ou de cloud qui n'est pas cité dans un fichier du projet.

## Étapes

### 1. Inventaire et arrêt si pas de code

Liste les fichiers source (noms seulement) :

```bash
{ if [ "$(git rev-parse --show-toplevel 2>/dev/null)" = "$(pwd -P)" ]; then git ls-files --cached --others --exclude-standard; else find . -type f | sed 's|^\./||'; fi; } \
  | grep -E '\.(ts|tsx|js|jsx|mjs|cjs|vue|svelte|dart|php|py|rb|go|java|kt|swift|cs|rs)$' \
  | grep -vE '(^|/)(node_modules|vendor|build|dist|\.dart_tool|docs/wf)/|\.d\.ts$|\.g\.dart$' | sort -u
```

- Répertoire vide : réponds « Le répertoire est vide : aucun livrable n'a été écrit. » et arrête-toi.
- Aucun fichier source : réponds « Le répertoire ne contient aucun code source : aucun livrable n'a été écrit. » et arrête-toi.

Stacks couvertes : web JavaScript/TypeScript (npm, pnpm, yarn) et Flutter (pub). Une autre stack est détectée et signalée « non couverte », sans analyse approfondie. Repère chaque application (manifeste `package.json`, `pubspec.yaml`… dans des dossiers distincts) : un monorepo en contient plusieurs.

### 2. Contexte git (en-tête)

- Le projet est un dépôt git si `git rev-parse --show-toplevel` renvoie le répertoire courant (`pwd -P`) ; sinon il est « hors git ».
- Commit analysé : `git rev-parse --short HEAD`.
- Arbre propre : `git status --porcelain -- . ':(exclude)docs/wf/analyse-projet.md'` vide. Sinon, l'en-tête ajoute « modifications non commitées » après le commit.
- Date du jour : `date +%F`.

### 3. Volume et périmètre de lecture

Si le projet compte plus de 300 fichiers source, compte-les par dossier parent direct (`<commande de l'étape 1> | sed 's|/[^/]*$||' | sort | uniq -c | sort -rn`) : un dossier qui en contient directement plus de 100 n'est pas lu (sauf les fichiers du top 10 de l'étape 5) et est noté comme non lu. Ils ne sont pris en compte dans aucune conclusion (couverture, sécurité, dette, architecture) ; ils sont listés dans « Points non déterminés ».

Lis ensuite les manifestes, lockfiles, configurations (CI, Docker, `.env.example`), points d'entrée, routes, services et tests.

### 4. Dépendances

- Version installée : celle du lockfile (`package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, `pubspec.lock`), à défaut celle du manifeste en le précisant.
- Dernière version publiée des dépendances directes, en une commande par écosystème :

```bash
for p in react express; do v=$(curl -s --max-time 10 "https://registry.npmjs.org/$p/latest" | grep -o '"version":"[^"]*"' | head -1); echo "$p ${v:-injoignable}"; done
for p in http; do v=$(curl -s --max-time 10 "https://pub.dev/api/packages/$p" | grep -o '"latest":{"version":"[^"]*"' | head -1); echo "$p ${v:-injoignable}"; done
```

- Cite chaque dépendance en retard d'au moins une version majeure sur une ligne : nom, version installée, dernière version publiée, registre interrogé.
- Registre injoignable : garde les versions du lockfile, écris « dernière version : non déterminée », et signale dans « Points non déterminés » le registre injoignable et le repli sur le lockfile. Ne complète jamais une version publiée de mémoire.

### 5. Activité du dépôt (git seulement)

```bash
git log --reverse --format=%ad --date=short HEAD | head -1   # premier commit
git log -1 --format=%ad --date=short HEAD                    # dernier commit
git shortlog -sn HEAD | wc -l                                # contributeurs
git rev-parse --is-shallow-repository                        # historique tronqué
git log --since="12 months ago" --no-merges --format= --name-only HEAD | grep -v '^$' | sort | uniq -c | sort -rn
```

- Top 10 : les 10 fichiers encore présents les plus modifiés sur les 12 derniers mois, avec leur nombre de commits, sur la branche courante. Un fichier modifié par un seul commit n'est pas un point chaud : s'il en reste moins de 10, dis-le.
- Clone superficiel (`true`) : la date du premier commit est « non déterminée » ; indique la période réellement couverte (« historique disponible du AAAA-MM-JJ au AAAA-MM-JJ ») et signale l'historique tronqué dans « Points non déterminés ».
- Hors git : la section indique « non applicable ».

### 6. Qualité et tests

Un fichier source est réputé couvert si un fichier de test l'importe ou porte son nom (`cart.ts` et `cart.test.ts`, `price_utils.dart` et `price_utils_test.dart`). Liste les fichiers non couverts (chemins complets), hors dossiers non lus :

```bash
files=$(<commande de l'étape 1>)
tests=$(grep -E '\.(test|spec)\.[jt]sx?$|_test\.dart$|(^|/)(__tests__|test|tests)/' <<<"$files")
for f in $(grep -vxF -e "$tests" <<<"$files"); do
  stem=$(basename "${f%.*}")
  grep -qE "(^|/)${stem}([._](test|spec))?\.[a-z]+$|(^|/)${stem}_test\.dart$" <<<"$tests" && continue
  [ -n "$tests" ] && grep -qE "import[^;]*['\"/]${stem}(\.[a-z]+)?['\"]" $tests 2>/dev/null && continue
  echo "$f"
done
```

Précise à chaque fois que cette heuristique est approximative (ni exécution des tests, ni mesure de couverture). Relève aussi la présence de lint, de CI, de TODO/FIXME.

### 7. Sécurité, dette, effort

- Sécurité : seulement les signaux visibles (requêtes concaténées, secrets en dur, authentification faible, dépendances très anciennes), chemins cités. Pas d'audit approfondi.
- Dette et risques : chaque risque a un niveau, exactement « élevé », « moyen » ou « faible », et cite au moins un fichier. Tout fichier à la fois dans le top 10 et non couvert y figure obligatoirement.
- Effort de reprise : faible, moyen ou élevé, justifié en renvoyant aux risques listés. Aucun chiffrage : aucun nombre de jours, semaines, heures ou mois-homme (c'est `wf-chiffrage`).

### 8. Écriture

- Si `docs/wf/analyse-projet.md` existe, relis-le puis réécris-le en entier : conserve ce qui reste vrai, corrige le reste, actualise la date et le commit de l'en-tête. Jamais de second fichier ni de section dupliquée.
- Respecte le modèle ci-dessous : les neuf sections en titres `##`, dans cet ordre, une seule fois chacune. Les sous-sections (`###`) ne reprennent pas un nom de section.
- Termine par un message court : chemin du livrable, effort de reprise, nombre de points non déterminés.

## Modèle du livrable

```markdown
# Analyse du projet

Outil : wf-analyse-projet · Date : AAAA-MM-JJ · Commit analysé : <hash court>[ · modifications non commitées]

(hors dépôt : « Commit analysé : hors git », sans aucun hash)

## Synthèse

Vue globale en quelques phrases : nature du projet, chaque application (web, mobile…), état général, principaux risques.

## Stack et dépendances

Par application : langages, frameworks, gestionnaire de paquets, lockfile.
- `react` : installée 17.0.2 (`package-lock.json`), dernière publiée X.Y.Z (registre npm), retard majeur.

## Architecture

### Application web (`src/`)

Organisation, points d'entrée, couches, chemins cités.

### Application mobile (Flutter, `mobile/`)

(une sous-section par application en monorepo)

## Activité du dépôt

- Premier commit : AAAA-MM-JJ · dernier commit : AAAA-MM-JJ · N contributeurs.
- Fichiers les plus modifiés sur 12 mois : `chemin` (N commits)…

(hors git : « non applicable »)

## Qualité et tests

Tests présents, outillage. Fichiers source non couverts : `chemin`…
Heuristique approximative : un fichier est réputé couvert si un test l'importe ou porte son nom.

## Sécurité

Signaux visibles, avec chemins.

## Dette et risques

- **élevé** : description (`chemin`).
- **moyen** : description (`chemin`).
- **faible** : description (`chemin`).

## Effort de reprise

Effort **moyen** : justification par les risques listés ci-dessus.

## Points non déterminés

- Hébergement de production : non déterminé.
- (registre injoignable et repli sur le lockfile, historique tronqué, dossiers non lus, stack non couverte…)
```
