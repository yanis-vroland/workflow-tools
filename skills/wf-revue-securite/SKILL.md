---
name: wf-revue-securite
description: Génère ou met à jour docs/wf/revue-securite.md, une revue de sécurité à usage interne du code et des dépendances du projet courant (web JS/TS et Flutter) - dépendances vulnérables d'après OSV.dev, injections, contrôle d'accès, secrets en clair, stockage non sécurisé, chaque constat rattaché à une catégorie OWASP, un fichier et une ligne, avec une recommandation. À utiliser avec /wf-revue-securite, ou quand on demande un audit ou une revue de sécurité du projet avant une livraison ou une reprise.
---

# wf-revue-securite

Tu rédiges, en français, une revue de sécurité du projet ouvert dans le répertoire courant (le projet cible). Elle va plus loin que les signaux visibles de `wf-analyse-projet` : chaque constat est rattaché à une catégorie OWASP, à un fichier et une ligne, et assorti d'une recommandation. Le livrable est **à usage interne** : il décrit des failles potentiellement non corrigées.

## Règles absolues

- **Écriture** : un seul fichier, `docs/wf/revue-securite.md`, écrit avec l'outil Write (qui crée `docs/wf/` au besoin ; pas de `mkdir`). Aucun autre fichier du projet n'est créé, modifié, déplacé ou supprimé, y compris les livrables des autres outils dans `docs/wf/`. Tu recommandes des corrections, tu n'en appliques aucune.
- **Analyse statique seulement** : ni test d'intrusion, ni requête vers une instance du projet, ni exécution du projet, de ses tests, de son installation ou de ses outils (npm, npx, yarn, pnpm, node, flutter, dart, docker…), ni analyseur externe (Semgrep, gitleaks, osv-scanner, audit de gestionnaire de paquets…), ni recherche dans l'historique git (`git log`, `git show`, `git grep`, `git blame`…) : seul l'état courant des fichiers compte.
- **Bash** ne sert qu'aux commandes données dans cette skill, recopiées telles quelles : `git rev-parse --short HEAD`, `git status --porcelain`, `date +%F`, les deux `git ls-files` de l'étape 2 (chacune seule, sans rien y ajouter), et les interrogations par `curl` de l'étape 4. Aucune autre commande, même en lecture (`ls`, `cat`, `find`, `grep`…) : pour lire, utilise Read, Glob et Grep.
- **Réseau** : seulement `api.osv.dev` (base d'avis de sécurité) et `pub.dev` (dépendances déclarées d'un paquet pub), en lecture. Tu n'envoies que des noms et des versions de paquets, et les identifiants des avis à lire, jamais de code ni de contenu du projet.
- **Secrets** : ne lis jamais, ni avec Read, ni avec Grep, ni avec Bash, un fichier d'environnement (`.env`, `.env.local`, `.env.production`…, tout `.env*` sauf `.env.example`) ni un fichier de secrets ou d'identifiants (`.envrc`, `.npmrc`, `.pypirc`, `android/key.properties`, keystores, clés et certificats). Leur seul nom, obtenu par `git ls-files`, peut être cité. Avec Grep, passe toujours le paramètre `glob` limité à des extensions de code (ex. `*.{ts,tsx,js,jsx,mjs,cjs,vue,dart}`) : un dossier seul peut contenir un fichier d'environnement.
- **Aucune valeur secrète dans le livrable** : toute valeur littérale de secret est remplacée par `[masqué]`. Aucun caractère de la valeur n'y figure : ni début, ni fin, ni longueur, ni ligne de code recopiée qui la contient.
- **Données personnelles** : aucune adresse e-mail (de contributeur ou autre) dans le livrable.
- **Honnêteté** : chaque constat s'appuie sur un fichier lu, cité avec son chemin relatif à la racine et son numéro de ligne. Ce qui n'a pas pu être établi est écrit « non déterminé », jamais deviné. Aucun avis de sécurité n'est cité de mémoire : seulement ceux que renvoie OSV.dev pendant l'exécution. Le livrable n'affirme jamais que le projet est sûr.
- Pas de question à l'utilisateur : tu travailles avec ce que contient le projet.

## Étape 1 : vérifier qu'il y a du code source

Avec Glob, cherche des fichiers de code (`.ts`, `.tsx`, `.js`, `.jsx`, `.mjs`, `.cjs`, `.vue`, `.dart`, `.py`, `.rb`, `.php`, `.go`, `.rs`, `.java`, `.kt`, `.swift`, `.cs`…) ou un manifeste (`package.json`, `pubspec.yaml`, `pyproject.toml`, `requirements.txt`, `go.mod`, `Cargo.toml`, `composer.json`, `Gemfile`, `pom.xml`, `build.gradle`), hors `node_modules/`, `.dart_tool/` et dossiers de build.

S'il n'y en a aucun (répertoire vide, ou seulement des documents), n'écris rien, ne crée aucun dossier, et termine par ce message : « Aucun code source trouvé dans ce répertoire : aucun livrable n'a été écrit. »

## Étape 2 : en-tête, applications et périmètre de lecture

- Date : `date +%F`.
- Commit : `git rev-parse --short HEAD`. Si la commande échoue (pas un dépôt git), écris « hors git ».
- `git status --porcelain` : si la sortie contient au moins une ligne qui ne concerne pas `docs/wf/revue-securite.md`, l'en-tête ajoute « modifications non commitées ».
- Applications : repère chaque application par son manifeste (`package.json` pour le web JavaScript/TypeScript, `pubspec.yaml` pour Flutter), à la racine ou dans un sous-dossier (monorepo), et donne-lui un nom court tiré de son manifeste, de son dossier ou du README. Référentiel appliqué : OWASP Top 10 (édition 2025) pour une application web JavaScript/TypeScript, OWASP Mobile Top 10 (édition 2024) pour une application Flutter.
- Stack non couverte (Python, PHP, Go, Java…, repérée par son manifeste ou ses fichiers source) : liste son dossier dans « Périmètre et méthode » avec la mention « stack <nom> non couverte en v1 » ; aucun de ses fichiers n'est lu, aucun constat ni aucune dépendance n'est rapporté pour elle. Dans un projet mixte, les parties JavaScript/TypeScript et Flutter sont analysées normalement.
- Fichiers source suivis par git (hors git : ceux trouvés par Glob) :

```bash
git ls-files -- '*.ts' '*.tsx' '*.js' '*.jsx' '*.mjs' '*.cjs' '*.vue' '*.dart'
```

- Fichiers d'environnement suivis par git (noms seulement, contenu jamais lu) :

```bash
git ls-files -- '.env*' '*/.env*'
```

Si un garde-fou de l'environnement refuse cette commande (elle cite un nom de fichier d'environnement), ne la contourne pas : cherche ces fichiers par Glob (`**/.env*`, noms seulement) ; leur suivi par git est alors non déterminé, et le constat de l'étape 5 porte le statut « à vérifier ».
Budget de lecture : environ 300 fichiers source (hors fichiers générés `*.g.dart`, `*.freezed.dart`, `*.min.js`). Au-delà, compte les fichiers par dossier parent direct dans la sortie du premier `git ls-files` et retire de la lecture les dossiers les plus volumineux, du plus gros au plus petit, jusqu'à repasser sous ce budget : ce sont les **dossiers non lus**. Ils sont listés dans « Points non déterminés », et nulle part ailleurs : aucune conclusion ne porte sur eux, et tes recherches Grep les excluent aussi (passe un `path` limité aux dossiers lus) : un résultat trouvé dans un dossier non lu n'est pas un constat.

## Étape 3 : livrable existant

Si `docs/wf/revue-securite.md` existe, lis-le d'abord. Tu le réécriras en entier avec Write : un seul livrable dans le fichier (jamais l'ancien suivi du nouveau), aucune copie datée ou numérotée.

Identifiants `Sn` (un seul espace de numérotation pour les dépendances et les constats) :

1. Relève chaque entrée `Sn` du livrable précédent et sa clé : pour une dépendance, l'écosystème, le nom et l'avis ; pour un constat, la catégorie, le fichier et le code visé (la ligne peut avoir bougé).
2. `Smax` est le plus grand entre le `Sn` de la ligne « Dernier identifiant attribué » de l'en-tête et le plus grand `Sn` présent dans le livrable.
3. Une entrée encore présente (même clé) garde son identifiant ; son contenu (ligne, version, niveau, statut) est mis à jour.
4. Une entrée dont la cause a disparu (fichier ou code corrigé ou supprimé, dépendance mise à jour au-delà de la version corrigée ou retirée) est retirée. Son identifiant n'est jamais réattribué.
5. Une nouvelle entrée reçoit `Smax + 1`, puis la suivante `Smax + 2`, etc., dans l'ordre du livrable. Aucun identifiant inférieur ou égal à `Smax` absent du livrable précédent n'est réutilisé, même pour combler un trou.
6. La ligne « Dernier identifiant attribué » porte ensuite le plus grand identifiant jamais attribué, nouveau ou ancien, même si l'entrée qui le portait vient d'être retirée.

Premier passage : numérote à partir de `S1`, dans l'ordre du livrable. Tant qu'aucun identifiant n'a été attribué, la ligne de l'en-tête porte « Dernier identifiant attribué : aucun ».

## Étape 4 : dépendances vulnérables

### Versions et liens

- Avec lockfile (`package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, `pubspec.lock`) : toutes les dépendances du lockfile sont vérifiées, directes et transitives, avec leur version installée.
  - Directe : déclarée dans le manifeste de l'application (`dependencies`, `devDependencies`, `optionalDependencies` de `package.json` ; `importers` de `pnpm-lock.yaml` ; `dependency: "direct main"`, `"direct dev"` ou `"direct overridden"` de `pubspec.lock`).
  - Transitive : toute autre entrée. Cite la dépendance directe qui l'introduit : dans `package-lock.json`, le dossier parent d'une entrée imbriquée (`node_modules/<a>/node_modules/<b>`) ou, pour une entrée à plat, le paquet dont le champ `dependencies` la cite, en remontant jusqu'à une dépendance directe ; dans `yarn.lock` et `pnpm-lock.yaml`, les dépendances déclarées par chaque paquet ; pour pub, le lockfile ne donne pas ce lien : lis les dépendances déclarées des dépendances directes sur pub.dev (commande ci-dessous). Faute de pouvoir l'établir, écris « transitive (introduite par : non déterminé) » et reprends-le dans « Points non déterminés ».
- Sans lockfile : seules les dépendances directes sont vérifiées, d'après les contraintes déclarées dans `package.json` ou `pubspec.yaml`. Interroge la plus basse version admise par la contrainte (`^1.2.3`, `~1.2.3`, `>=1.2.3 <2.0.0` → `1.2.3` ; version exacte telle quelle). Une contrainte sans borne basse (`*`, `latest`, `any`, dépôt git, chemin local) n'est pas vérifiée et va dans « Points non déterminés ». La colonne « Version installée » porte « non déterminée (contrainte `<contrainte>`, vérifiée en <version>) », et « Points non déterminés » indique que les versions installées et les dépendances transitives n'ont pas pu être établies, faute de lockfile.
- Aucune dépendance déclarée : rien à interroger ; la section porte « aucun constat ».

### Interroger OSV.dev

Un nom, une version ou un identifiant d'avis lu dans le projet ou dans une réponse n'est **jamais écrit dans le texte d'une commande**, même entre apostrophes : bash l'analyserait avant toute validation, et un nom piégé (apostrophe suivie d'une substitution de commande) s'exécuterait. Il est écrit, un paquet ou un avis par ligne (les lignes de paquets commencent par le mot `paquet`, recopié tel quel), dans le corps d'un heredoc dont le délimiteur est entre apostrophes (`<<'OSV_PKGS_9f2c'`) : bash n'interprète rien de ce corps. Avant de l'y écrire, écarte toute ligne qui contient le délimiteur, une espace dans un nom ou une version, ou un retour à la ligne, et signale le paquet comme non vérifié. Chaque valeur est ensuite validée en bash avant tout usage : seuls les caractères `A-Za-z0-9@/._~+-` sont admis (donc ni apostrophe, ni guillemet, ni `$`, ni accent grave) ; une ligne refusée est signalée comme non vérifiée dans « Points non déterminés ». Écosystèmes OSV : `npm` pour npm, pnpm et yarn, `Pub` pour pub. Au plus 500 paquets par commande ; au-delà, plusieurs commandes.

```bash
q=""; labels=()
q_add() {
  [[ ($1 == npm || $1 == Pub) && $2 =~ ^(@[A-Za-z0-9._~-]+/)?[A-Za-z0-9._~-]+$ && $3 =~ ^[0-9A-Za-z.+-]+$ ]] || { echo "paquet ignoré, nom ou version invalide (non vérifié) : $1 $2 $3"; return; }
  q+="${q:+,}{\"package\":{\"ecosystem\":\"$1\",\"name\":\"$2\"},\"version\":\"$3\"}"
  labels+=("$1 $2 $3")
}
while read -r _ eco name version; do q_add "$eco" "$name" "$version"; done <<'OSV_PKGS_9f2c'
paquet npm <nom> <version>
paquet Pub <nom> <version>
OSV_PKGS_9f2c
out=$(curl -sS --max-time 60 -w '\n%{http_code}' -H 'Content-Type: application/json' -d "{\"queries\":[$q]}" https://api.osv.dev/v1/querybatch); rc=$?; code=${out##*$'\n'}
if [ "$rc:$code" = "0:200" ]; then
  i=0
  while IFS= read -r item; do
    ids=$(grep -oE '"id":"[^"]+"' <<<"$item" | cut -d'"' -f4 | tr '\n' ' ')
    [ -n "$ids" ] && echo "${labels[$i]} : $ids"
    case $item in *next_page_token*) echo "${labels[$i]} : réponse paginée, avis incomplets (non déterminé)" ;; esac
    i=$((i + 1))
  done < <(printf '%s' "${out%$'\n'*}" | tr -d ' \n\r\t' | grep -oE '\{"vulns":\[[^]]*\][^{}]*\}|\{\}')
  echo "osv.dev : ${#labels[@]} paquets interrogés, $i réponses"
else
  echo "osv.dev injoignable (curl $rc, HTTP $code)"
fi
```

Si le nombre de réponses diffère du nombre de paquets interrogés, ou si une réponse est paginée, les paquets concernés sont « non déterminé » et vont dans « Points non déterminés ». Puis, pour chaque identifiant d'avis renvoyé (un par ligne du heredoc), lis l'avis :

```bash
while read -r id; do
  [[ $id =~ ^[A-Za-z0-9._:-]+$ ]] || { echo "identifiant d'avis invalide, ignoré : $id"; continue; }
  out=$(curl -sS --max-time 20 -w '\n%{http_code}' "https://api.osv.dev/v1/vulns/$id"); rc=$?; code=${out##*$'\n'}
  if [ "$rc:$code" = "0:200" ]; then
    printf '%s' "${out%$'\n'*}" | tr -d '\n' | sed -E 's/"details": ?"([^"\\]|\\.)*",?//; s/"references": ?\[[^]]*\],?//; s/,? ?"versions": ?\[[^]]*\]//g'; echo
  else
    echo "osv.dev injoignable pour $id (curl $rc, HTTP $code)"
  fi
done <<'OSV_IDS_9f2c'
<identifiant>
OSV_IDS_9f2c
```

Dépendances déclarées d'un paquet pub (lien d'une transitive pub seulement ; une ligne `paquet <nom> <version>` par dépendance directe) :

```bash
while read -r _ name version; do
  [[ $name =~ ^[a-z0-9_]+$ && $version =~ ^[0-9A-Za-z.+-]+$ ]] || { echo "paquet pub invalide, ignoré : $name $version"; continue; }
  out=$(curl -sS --max-time 20 -w '\n%{http_code}' "https://pub.dev/api/packages/$name/versions/$version"); rc=$?; code=${out##*$'\n'}
  if [ "$rc:$code" = "0:200" ]; then
    deps=$(printf '%s' "${out%$'\n'*}" | tr -d '\n' | awk '{ i = index($0, "\"dependencies\":{"); if (!i) exit; d = 0; for (j = i + 15; j <= length($0); j++) { c = substr($0, j, 1); if (c == "{") d++; else if (c == "}" && --d == 0) { print substr($0, i, j - i + 1); exit } } }')
    echo "$name $version : ${deps:-aucune dépendance déclarée}"
  else
    echo "pub.dev injoignable pour $name $version (curl $rc, HTTP $code)"
  fi
done <<'PUB_PKGS_9f2c'
paquet <nom> <version>
PUB_PKGS_9f2c
```

### Ce qu'on retient de chaque avis

- Identifiant : celui d'OSV (GHSA, CVE ou identifiant OSV), suivi entre parenthèses de ses alias CVE s'il en a.
- Attribution : vérifie que le champ `affected` de l'avis vise bien le paquet (écosystème et nom) auquel la requête par lot l'a rattaché ; en cas d'écart, c'est `affected` qui fait foi, et l'écart est signalé dans « Points non déterminés ».
- Sévérité publiée, reprise telle quelle : le champ `database_specific.severity` (ex. `HIGH`, `MODERATE`) ; à défaut, le vecteur CVSS du champ `severity` ; à défaut, « non publiée ». Jamais la grille élevé, moyen, faible des constats du code.
- Première version corrigée : dans `affected` (même écosystème, même nom), l'événement `fixed` de l'intervalle qui contient la version installée ; sans `fixed` (seulement `last_affected`, ou aucun), écris « aucune correction publiée ».
- Un avis qui ne vise pas la version installée (hors de tous les intervalles) n'est pas retenu.
- Une ligne par couple (dépendance, avis), avec son identifiant `Sn`.

### Base d'avis injoignable

Si OSV.dev ne répond pas (sortie « osv.dev injoignable »), « Dépendances vulnérables » porte exactement « non déterminé (base d'avis injoignable) », sans aucun avis cité, et « Points non déterminés » le reprend ; la « Synthèse » donne les dépendances comme non déterminées. Aucune entrée de dépendance du livrable précédent n'est reconduite : ses identifiants sont retirés (étape 3) et ne seront jamais réattribués. Le reste de la revue est produit normalement.

## Étape 5 : constats dans le code et secrets

Lis les points d'entrée, routes, middlewares, contrôleurs, accès aux données, services d'authentification, stockage local et configuration (serveur, origines croisées, en-têtes, manifestes Android et iOS, `.env.example`) de chaque application couverte, dans les dossiers lus.

### Forme de chaque entrée

Identifiant `Sn`, application, niveau, catégorie (libellé français suivi de la catégorie OWASP du référentiel de l'application), emplacement (au moins un `chemin:ligne`), route et méthode HTTP pour un constat de contrôle d'accès, description factuelle, recommandation, statut.

| Catégorie | OWASP Top 10 (2025), web | OWASP Mobile Top 10 (2024), Flutter |
|---|---|---|
| injection | A05:2025 Injection | M4:2024 Insufficient Input/Output Validation |
| contrôle d'accès | A01:2025 Broken Access Control | M3:2024 Insecure Authentication/Authorization |
| authentification | A07:2025 Authentication Failures | M3:2024 Insecure Authentication/Authorization |
| secret exposé | A07:2025 Authentication Failures | M1:2024 Improper Credential Usage |
| stockage non sécurisé | A04:2025 Cryptographic Failures | M9:2024 Insecure Data Storage |
| configuration | A02:2025 Security Misconfiguration | M8:2024 Security Misconfiguration |
| cryptographie | A04:2025 Cryptographic Failures | M10:2024 Insufficient Cryptography |
| communication non sécurisée | A04:2025 Cryptographic Failures | M5:2024 Insecure Communication |
| intégrité | A08:2025 Software or Data Integrity Failures | M7:2024 Insufficient Binary Protections |
| journalisation | A09:2025 Security Logging and Alerting Failures | M8:2024 Security Misconfiguration |
| gestion des erreurs | A10:2025 Mishandling of Exceptional Conditions | M8:2024 Security Misconfiguration |

### Niveau (constats du code et des secrets)

- **élevé** : exploitable sans authentification, ou expose un secret ou les données d'autres utilisateurs ;
- **moyen** : exploitable par un utilisateur authentifié, ou sous une condition identifiée (ex. accès physique à l'appareil) ;
- **faible** : durcissement sans exploitation identifiée.

La description justifie le niveau par la grille (ex. « route protégée par le middleware d'authentification : exploitable par un utilisateur authentifié »).

### Statut

- **confirmé** : le code lu suffit à établir le constat.
- **à vérifier** : sa réalité dépend d'un élément que tu n'as pas pu lire (configuration serveur ou d'un proxy, middleware global introuvable, valeur d'une variable d'environnement, fichier d'un dossier non lu). La description nomme cet élément (ex. « dépend de la variable d'environnement `SESSION_SECRET`, non lue »). En particulier, une valeur littérale de secret utilisée seulement comme valeur par défaut d'une variable d'environnement (elle ne sert que si la variable est absente) garde le niveau élevé, mais son statut est « à vérifier », et la description nomme la variable.

### Ce qu'il faut rechercher, au minimum

- **injection** : requête SQL ou NoSQL construite par concaténation ou interpolation d'une valeur non maîtrisée (paramètre de route, corps ou query de la requête, argument d'une fonction appelée avec une saisie), y compris `rawQuery`, `rawInsert`, `execute` de `sqflite` avec une valeur interpolée en Dart (`$x`, `${x}`) ; commande système, `eval`, chemin de fichier construit depuis une saisie ; injection de HTML (`innerHTML`, `dangerouslySetInnerHTML`, `v-html`) depuis une valeur non maîtrisée. Cite le fichier et la ligne de la requête.
- **contrôle d'accès** : chaque route d'API qui crée, modifie ou supprime des données (POST, PUT, PATCH, DELETE, ou mutation GraphQL) sans contrôle d'authentification ou d'autorisation identifiable dans sa déclaration, un middleware de son routeur, un middleware global monté avant elle, ou un garde ou décorateur qui la couvre. Cite la route complète, préfixe de montage compris, et sa méthode (ex. `PUT /<préfixe>/<ressource>/:<paramètre>`), avec le fichier et la ligne. Si un middleware global est référencé mais introuvable, le statut est « à vérifier ». Signale aussi une vérification d'appartenance manquante (un utilisateur authentifié qui agit sur la ressource d'un autre).
- **secret exposé** (section « Secrets et configuration ») : dans les fichiers `.js`, `.ts`, `.jsx`, `.tsx` et `.dart` suivis par git (première commande `git ls-files`), toute valeur littérale non vide affectée, directement ou comme valeur par défaut d'un calcul, à une variable, une constante, un champ ou une clé dont le nom contient `password`, `secret`, `token`, `apikey` ou `api_key`, casse ignorée (ex. `clientSecret`, `refresh_token`, `ApiKeyValue`). Recherche-les avec Grep (motif `` (password|secret|token|api_?key)[^\n]*['"`] ``, `-i`, `-n`, `glob` `*.{js,ts,jsx,tsx,dart}`), puis lis chaque ligne trouvée et écarte celles où aucune valeur littérale n'est affectée au nom repéré (type, paramètre, lecture d'une variable d'environnement sans valeur par défaut, interpolation). Chaque valeur trouvée donne un constat de niveau **élevé**, avec le fichier et la ligne, où la valeur est remplacée par `[masqué]`. Recommandation : sortir la valeur du code (variable d'environnement, coffre de secrets, paramètre de compilation) et la renouveler, puisqu'elle figure dans le dépôt.
- **fichier d'environnement suivi** (section « Secrets et configuration ») : chaque fichier listé par la seconde commande `git ls-files`, sauf `.env.example`, donne un constat de niveau **élevé** qui cite son chemin, sans que tu aies lu son contenu (« contenu non lu »). Recommandation : le retirer du suivi, l'ajouter au `.gitignore` et renouveler les secrets qu'il contient. Hors git, cette vérification est « non applicable ».
- **stockage non sécurisé** : jeton, mot de passe ou secret enregistré avec `shared_preferences` (stockage non chiffré) dans une application Flutter, ou dans le stockage Web du navigateur côté web. Cite le fichier et la ligne de l'écriture. Recommandation : stockage chiffré (`flutter_secure_storage`, trousseau iOS, Keystore Android ; côté web, cookie inaccessible au JavaScript de la page).
- **configuration** : politique d'origines croisées qui accepte toute origine, absence d'en-têtes de sécurité ou de politique CSP configurés dans le code (statut « à vérifier » : un proxy ou un serveur non décrit dans le dépôt peut les poser), mode debug activé, trafic en clair autorisé (`usesCleartextTraffic`, `NSAllowsArbitraryLoads`, URL `http://` vers une API distante).
- **authentification** et **cryptographie** : absence de protection contre la force brute à la connexion, jeton sans expiration ou à expiration très longue, algorithme de hachage de mot de passe faible (`md5`, `sha1`), vérification de signature désactivée.

## Modèle du livrable

Titres de section en `##`, exactement dans cet ordre, sans table des matières. Entrées de constat en `###`.

```markdown
# Revue de sécurité de <nom du projet>

Outil : wf-revue-securite · Date : AAAA-MM-JJ · Commit : <sha court ou « hors git »>[ · modifications non commitées] · Dernier identifiant attribué : S<n>

> **Document à usage interne.** Il décrit des failles potentiellement non corrigées : il ne doit pas être diffusé hors de l'équipe.

## Synthèse

- Constats : <n> élevé, <n> moyen, <n> faible.
- Dépendances vulnérables : <n> dépendances visées par <n> avis ; par sévérité publiée : <n> CRITICAL, <n> HIGH, <n> MODERATE, <n> LOW, <n> sans sévérité publiée (ou « aucun constat », ou « non déterminé (base d'avis injoignable) »).
- À traiter en priorité : S<n>, S<n> (constats de niveau élevé et dépendances de sévérité critique ou élevée), ou « aucun ».
- Limites : analyse statique de l'état courant du code, sans test d'intrusion, sans exécution du projet, sans analyseur externe et sans recherche dans l'historique git ; elle ne garantit pas l'absence de faille.

## Périmètre et méthode

- Applications analysées :
  - <Application> (`<dossier>`, JavaScript/TypeScript) : OWASP Top 10 (édition 2025)
  - <Application> (`<dossier>`, Flutter) : OWASP Mobile Top 10 (édition 2024)
  - `<dossier>` : stack <nom> non couverte en v1, non analysée
- Dossiers analysés : `<dossier>`, `<dossier>`.
- Méthode : analyse statique de l'état courant du code, sans test d'intrusion, sans exécution du projet, sans analyseur externe et sans recherche dans l'historique git. Avis de sécurité des dépendances : base OSV.dev (`api.osv.dev`), interrogée le AAAA-MM-JJ avec les seuls noms et versions des paquets.

## Dépendances vulnérables

| Id | Application | Dépendance | Écosystème | Version installée | Lien | Avis | Sévérité publiée | Première version corrigée |
|---|---|---|---|---|---|---|---|---|
| S<n> | <Application> | `<nom>` | npm | <version> | directe | <GHSA-…> (<CVE-…>) | <sévérité publiée> | <version ou « aucune correction publiée »> |
| S<n> | <Application> | `<nom>` | pub | <version> | transitive (via `<dépendance directe>`) | <identifiant> | <sévérité publiée> | <version> |

## Constats dans le code

### S<n> · <titre court>

- Application : <Application>
- Niveau : élevé | moyen | faible
- Catégorie : <libellé> (<catégorie OWASP>)
- Emplacement : `<chemin>:<ligne>`
- Route : `<MÉTHODE> <chemin complet>` (contrôle d'accès seulement)
- Description : <constat factuel, justification du niveau ; pour « à vérifier », l'élément non lu>
- Recommandation : <correction proposée>
- Statut : confirmé | à vérifier

## Secrets et configuration

### S<n> · <titre court>

- Application : <Application>
- Niveau : élevé
- Catégorie : secret exposé (<catégorie OWASP>)
- Emplacement : `<chemin>:<ligne>`
- Description : valeur littérale `[masqué]` affectée à `<nom>`.
- Recommandation : <correction proposée>
- Statut : confirmé | à vérifier

## Points non déterminés

- <Point, avec les fichiers ou dossiers concernés.>
```

## Remplir chaque section

**Synthèse** : les nombres viennent des entrées des sections suivantes. La ligne « Limites » figure toujours. Quand rien n'est trouvé, écris « aucun constat » pour les constats et les dépendances, garde la ligne « Limites », et n'écris jamais que le projet est sûr, sécurisé ou sans faille.

**Périmètre et méthode** : une ligne par application avec son dossier, sa stack et son référentiel ; une ligne par stack non couverte ; les dossiers analysés (les dossiers non lus ne sont cités que dans « Points non déterminés ») ; la phrase de méthode du modèle, toujours.

**Dépendances vulnérables** : le tableau, une ligne par couple (dépendance, avis), ou « aucun constat », ou « non déterminé (base d'avis injoignable) ». La colonne « Lien » porte « directe » ou « transitive (via `<dépendance directe>`) ». En monorepo, la colonne « Application » dit quel manifeste ou lockfile la déclare.

**Constats dans le code** et **Secrets et configuration** : une entrée `###` par constat, au format du modèle, triées par niveau (élevé, moyen, faible) à la première exécution. « Secrets et configuration » reçoit les secrets exposés, les fichiers d'environnement suivis et les constats de configuration ; les autres vont dans « Constats dans le code ». Sans entrée, écris « aucun constat ». Chaque entrée indique son application.

**Points non déterminés** : liste à puces de tout ce qui n'a pas pu être établi : base d'avis injoignable, absence de lockfile (versions installées et dépendances transitives non établies), dépendance directe d'une transitive non établie, paquets non vérifiés, dossiers non lus, éléments non lus dont dépend un constat « à vérifier », stack non couverte. S'il n'y a rien : « - Aucun. »

## Contrat avec wf-montee-version

Le chemin `docs/wf/revue-securite.md`, les identifiants `Sn` et la section « Dépendances vulnérables » (son nom et les colonnes de son tableau : identifiant, application, dépendance, écosystème, version installée, lien, avis, sévérité publiée, première version corrigée) sont lus par `wf-montee-version` (spec 013). Ne les change pas sans mettre à jour cette spec.

## Fin

Écris le livrable avec Write dans `docs/wf/revue-securite.md`, puis termine par un message court : chemin du livrable, création ou mise à jour, nombre de constats par niveau et de dépendances vulnérables, et rappel qu'il est à usage interne.
