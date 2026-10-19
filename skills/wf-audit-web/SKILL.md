---
name: wf-audit-web
description: Génère ou met à jour docs/wf/audit-web.md, un audit remettable au client de la performance, de l'accessibilité (RGAA 4.1), du référencement et des bonnes pratiques du ou des fronts web JavaScript/TypeScript du projet courant, avec des constats identifiés (W1, W2…), localisés et priorisés dans un plan d'action. Audit du code seul par défaut ; avec une URL en argument, ajoute une mesure Lighthouse de cette seule page si Lighthouse est déjà installé. À utiliser avec /wf-audit-web [URL], ou quand on demande un audit web, d'accessibilité, de performance ou de SEO d'un site avant mise en ligne.
---

# wf-audit-web

Tu rédiges, en français, l'audit du ou des fronts web JavaScript/TypeScript du projet ouvert dans le répertoire courant (le projet cible) : performance, accessibilité, référencement et bonnes pratiques. Le livrable est remis au client : ton factuel, phrases courtes, tout terme technique expliqué en quelques mots à sa première apparition (ex. « attribut `alt` : texte qui remplace l'image pour les lecteurs d'écran »). Il identifie et priorise des corrections ; il ne corrige rien.

Référentiel d'accessibilité : **RGAA 4.1**. Le critère WCAG correspondant peut être ajouté entre parenthèses.

## Règles absolues

- **Écriture** : un seul fichier, `docs/wf/audit-web.md`, écrit avec l'outil Write (qui crée `docs/wf/` au besoin ; pas de `mkdir`). Aucun autre fichier du projet n'est créé, modifié, déplacé ou supprimé : pas de correction du code, pas de rapport Lighthouse enregistré, pas de copie datée de l'audit. Les livrables des autres outils dans `docs/wf/` sont seulement lus.
- **Bash** : uniquement les commandes suivantes, recopiées telles quelles, chacune seule (sans option ajoutée, redirection, variable, sous-shell ni enchaînement, sauf les tubes prévus dans les commandes 5 et 7) :
  1. `git rev-parse --short HEAD`
  2. `git status --porcelain`
  3. `date +%F`
  4. la recherche des images lourdes, lancée depuis la racine du projet :
     `find . \( -name node_modules -o -name .git -o -name dist -o -name build -o -name .next -o -name out -o -name coverage \) -prune -o -type f \( -path '*/public/*' -o -path '*/static/*' -o -path '*/assets/*' \) \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.gif' -o -iname '*.webp' -o -iname '*.avif' -o -iname '*.svg' -o -iname '*.bmp' -o -iname '*.ico' -o -iname '*.tif' -o -iname '*.tiff' \) -size +200000c -exec wc -c {} +`
  5. le décompte des gabarits et composants par dossier, lancé depuis la racine du projet (une ligne par dossier : nombre de fichiers, puis dossier) :
     `find . \( -name node_modules -o -name .git -o -name dist -o -name build -o -name .next -o -name out -o -name coverage \) -prune -o -type f \( -iname '*.html' -o -iname '*.htm' -o -iname '*.tsx' -o -iname '*.jsx' -o -iname '*.vue' -o -iname '*.svelte' -o -iname '*.astro' \) -exec dirname {} + | sort | uniq -c`
  6. en mode URL seulement : `command -v lighthouse`
  7. en mode URL seulement, si Lighthouse est installé, une seule fois :
     `lighthouse '<URL>' --output=json --output-path=stdout --quiet --chrome-flags='--headless=new' | node '<dossier de la skill>/scripts/lighthouse-summary.mjs'`

  Aucune autre commande, même en lecture (`ls`, `cat`, `curl`…). Tu ne lances ni le projet, ni ses tests, ni son build, ni son installation. Pour lire, utilise Read, Glob et Grep.
- **Aucune installation** : tu n'installes jamais Lighthouse ni aucun paquet : ni `npm install`, ni `npx` (qui téléchargerait le paquet), ni autre gestionnaire.
- **Une seule page chargée** : en mode URL, seule l'URL passée en argument est chargée, par la commande Lighthouse ci-dessus. Aucune autre page du site n'est explorée : pas de WebFetch, pas de `curl`, ni sitemap, ni `robots.txt`, ni lien suivi.
- **Secrets** : ne lis jamais, ni avec Read, ni avec Grep, ni avec Bash, un fichier d'environnement (`.env`, `.env.local`, `.env.production`…, sauf `.env.example`) ni un fichier de secrets ou d'identifiants (`.envrc`, `.npmrc`, clés et certificats). Avec Grep, passe toujours le paramètre `glob` limité à des extensions de code ou de gabarit (ex. `*.{html,htm,ts,tsx,js,jsx,mjs,vue,svelte,astro}`), même quand la recherche porte sur un dossier de code : un dossier seul peut contenir un fichier d'environnement. Aucune valeur de variable d'environnement dans l'audit.
- **Données personnelles** : aucune adresse e-mail (de contributeur ou autre) dans l'audit.
- **Honnêteté** : chaque constat s'appuie sur un fichier que tu as lu avec Read (une correspondance Grep sert à repérer, jamais à conclure) ou sur la mesure Lighthouse ; les chemins sont relatifs à la racine du projet. Ce qui n'a pas pu être établi est écrit « non déterminé », jamais deviné, et figure dans « Points non déterminés ».
- **Périmètre** : ni revue de sécurité (en-têtes de sécurité, CSP, CORS, stockage des jetons, injections : c'est `wf-revue-securite`), ni recette fonctionnelle, ni audit de conformité RGAA complet (pas de taux de conformité, pas de déclaration d'accessibilité), ni éco-conception (RGESN), ni estimation de charge. En mode URL, les points de sécurité que Lighthouse range dans « Bonnes pratiques » sont repris tels quels, sans analyse.

## Étape 1 : vérifier qu'il y a du code source

Avec Glob, cherche des fichiers de code (`.ts`, `.tsx`, `.js`, `.jsx`, `.vue`, `.svelte`, `.astro`, `.html`, `.dart`, `.py`, `.rb`, `.php`, `.go`, `.java`, `.kt`, `.swift`, `.cs`…) ou un manifeste (`package.json`, `pubspec.yaml`, `composer.json`, `pyproject.toml`, `Gemfile`, `go.mod`…), hors `node_modules/` et dossiers de build.

S'il n'y en a aucun (répertoire vide, ou seulement des documents), n'écris rien, ne crée aucun dossier, et termine par ce message : « Aucun code source trouvé dans ce répertoire : aucun audit n'a été écrit. »

## Étape 2 : repérer les fronts web

Repère chaque application (un manifeste par dossier) et classe-la :

- **Front web JS/TS, audité** : un `package.json` qui dépend d'un framework ou d'un outil de front (`react`, `react-dom`, `next`, `vue`, `nuxt`, `svelte`, `@sveltejs/kit`, `@angular/core`, `astro`, `preact`, `solid-js`, `vite` avec un document HTML…), ou des gabarits `.html`, `.tsx`, `.jsx`, `.vue`, `.svelte`, `.astro` servis par une application JS/TS. Donne à chaque front un nom court (tiré de son manifeste, de son dossier ou du README) et note son dossier.
- **Application Flutter** (`pubspec.yaml`) : exclue, avec la mention « application mobile, cible web Flutter non couverte en v1 ».
- **Front web d'une autre stack** (gabarits PHP, Twig, ERB, Django, Razor…) : signalé « non couvert » dans « Périmètre et méthode », sans aucun constat, même s'il présente des défauts visibles.
- **Code sans interface** (API, bibliothèque, script) : ni audité ni signalé comme front.

S'il n'y a aucun front web JS/TS, n'écris rien, ne crée aucun dossier, et termine par un message qui dit ce que contient le projet et pourquoi rien n'est audité, sur ce modèle : « Aucun front web JavaScript/TypeScript dans ce projet (<ce qui a été trouvé, ex. API seule, ou application Flutter seule : cible web Flutter non couverte en v1>) : aucun audit n'a été écrit. »

## Étape 3 : préparer l'en-tête

- Date : `date +%F` (format AAAA-MM-JJ).
- Commit : `git rev-parse --short HEAD`. Si la commande échoue (pas un dépôt git, ou dépôt sans commit), écris « hors git ».
- `git status --porcelain` : si la sortie contient au moins une ligne qui ne concerne pas `docs/wf/audit-web.md`, ajoute la mention « modifications non commitées ». Sinon, ne l'écris pas.

## Étape 4 : choisir le mode

- **Sans argument** : mode « code seul ».
- **Avec une URL en argument** (`/wf-audit-web https://…`) : vérifie qu'elle commence par `http://` ou `https://` et ne contient ni espace ni apostrophe ; sinon, audite le code seul et signale l'argument écarté dans « Périmètre et méthode » et « Points non déterminés ». Puis lance `command -v lighthouse` :
  - **Lighthouse absent** (sortie vide ou échec) : ne l'installe pas. Mode « code seul ». « Périmètre et méthode » cite l'URL demandée et indique que Lighthouse est absent du poste ; « Points non déterminés » donne la commande à lancer soi-même pour un audit mesuré : `npm install -g lighthouse` (Lighthouse exige aussi Chrome ou Chromium).
  - **Lighthouse présent** : lance la commande 7 une seule fois, en remplaçant `<URL>` par l'URL et `<dossier de la skill>` par le chemin absolu du dossier de cette skill, indiqué en tête de ces instructions (« Base directory for this skill »), tous deux entre apostrophes comme dans la commande. Si ce chemin n'est pas connu ou contient une apostrophe, ne lance rien et traite le cas comme une mesure impossible (même traitement que l'URL injoignable). Le script `scripts/lighthouse-summary.mjs` résume le rapport JSON de Lighthouse sans rien écrire sur le disque :
    - `"status": "unreachable"` : la page n'a pas pu être chargée (URL injoignable, erreur de Lighthouse). Mode « code seul » ; l'URL demandée et la cause sont signalées dans « Périmètre et méthode » et dans « Points non déterminés » ; l'audit est tout de même produit.
    - `"status": "ok"` : mode « code + URL ». Le résumé donne la version de Lighthouse (`lighthouseVersion`), l'heure de la mesure (`fetchTime`, en UTC), le profil d'appareil (`formFactor`, mobile), l'URL demandée (`requestedUrl`) et l'URL finalement auditée (`finalUrl`, `redirected`), les scores sur 100 des quatre catégories (`scores`) et les audits en échec (`issues`, avec les URL des ressources et les extraits HTML en cause).

## Étape 5 : livrable existant

Si `docs/wf/audit-web.md` existe, lis-le d'abord, en particulier la ligne « Dernier identifiant attribué : W<n> » et chaque constat. Tu le réécriras en entier avec Write : un seul audit dans le fichier (jamais l'ancien suivi du nouveau), date et commit mis à jour. Ne crée aucun autre fichier.

## Étape 6 : lire le code

Pour chaque front audité, liste avec Glob ses documents HTML, gabarits de mise en page et pages (documents `*.html`, puis les gabarits et les pages que désignent les conventions de routage par fichiers du framework : Next.js, Nuxt, SvelteKit, Astro…), puis ses composants (`.tsx`, `.jsx`, `.vue`, `.svelte`, `.astro`, `.html`), hors `node_modules/` et dossiers de build. Repère les candidats avec Grep (`<img`, `<Image`, `<input`, `<select`, `<textarea`, `<html`, `<title`, `metadata`, `description`…), puis lis chaque fichier concerné avec Read avant d'en tirer un constat : une balise JSX peut s'étendre sur plusieurs lignes, et ses attributs peuvent venir d'une décomposition (`{...props}`) : dans ce cas, le point est « non déterminé ».

**Inventaire** : lance d'abord la commande 5. Elle donne, pour chaque dossier, le nombre exact de gabarits et de composants : c'est la seule source pour compter les fichiers et lister les dossiers, car le résultat de Glob peut être tronqué (au-delà d'une centaine de fichiers) et ne montrerait alors qu'une partie des dossiers.

**Projet volumineux** : au-delà de 150 fichiers de gabarits et de composants (total de la commande 5), lis d'abord les documents racine, les gabarits de mise en page et les pages, puis les composants dossier par dossier, sans dépasser 150 fichiers lus. Chaque dossier de la commande 5 dont tous les fichiers n'ont pas été lus figure dans « Points non déterminés », sous la mention « dossiers non lus » (ou « lus en partie »), un par ligne avec son nombre de fichiers tel que la commande 5 le donne (un dossier parent entièrement non lu peut regrouper ses sous-dossiers, à condition de les nommer tous), et aucune conclusion ne porte sur lui : ni constat général, ni affirmation qu'il est exempt de problème. Une correspondance Grep dans un fichier non lu n'est pas un constat.

## Règles de constat

### Accessibilité (RGAA 4.1)

Chaque constat d'accessibilité cite le numéro du critère RGAA 4.1 sous la forme « RGAA <n>.<m> », éventuellement suivi du critère WCAG entre parenthèses.

- **Image sans alternative, RGAA 1.1 (WCAG 1.1.1)** : une balise `<img>`, ou le composant image du framework (ex. `<Image>` de Next.js, `<NuxtImg>`), sans attribut `alt`. Un `alt=""` (image décorative) n'est pas un constat. Fichier et ligne de la balise.
- **Champ sans libellé, RGAA 11.1 (WCAG 1.3.1, 4.1.2)** : un `<input>` (hors `type="hidden"`, `submit`, `button`, `reset`, `image`), `<select>` ou `<textarea>` sans libellé associé : ni `<label for>` (`htmlFor` en JSX) désignant son `id`, ni `<label>` qui l'englobe, ni `aria-label`, ni `aria-labelledby`. Un `placeholder` seul n'est pas un libellé. Fichier et ligne du champ. Un composant de formulaire d'une bibliothèque dont le rendu n'est pas lisible dans le dépôt est « non déterminé ».
- **Langue non déclarée, RGAA 8.3 (WCAG 3.1.1)** : un document HTML racine ou un gabarit de mise en page dont la balise `<html>` n'a pas d'attribut `lang`. Fichier et ligne de la balise. Si la balise `<html>` est générée par le framework sans être définie dans le dépôt, le point est « non déterminé ».
- **Page sans titre, RGAA 8.5 (WCAG 2.4.2)** : une page ou une route pour laquelle aucun titre n'est défini, ni `<title>`, ni mécanisme du framework (`metadata.title` ou `generateMetadata` de Next.js, `<Head><title>`, `useHead`, `document.title`, configuration `app.head` de Nuxt…). Un titre défini par un gabarit de mise en page vaut pour les routes qu'il englobe. Le constat cite la route (ex. `/`, ou « toutes les routes » d'une application monopage servie par un seul document) et le fichier. Une page sans titre donne aussi un constat de référencement (ci-dessous).
- En mode URL, les audits d'accessibilité de Lighthouse en échec sont repris avec leur critère RGAA 4.1 : `image-alt`, `input-image-alt` → 1.1 ; `label`, `select-name` → 11.1 ; `html-has-lang` → 8.3 ; `html-lang-valid` → 8.4 ; `document-title` → 8.5 ; `duplicate-id` → 8.2 ; `color-contrast` → 3.2 ; `link-name` → 6.2 ; `button-name` → 11.9 ; `heading-order` → 9.1 ; `list`, `listitem` → 9.3 ; `frame-title` → 2.1 ; `meta-viewport` → 10.4 ; `tabindex` → 12.8 ; audits `aria-*` → 7.1. Un audit sans correspondance certaine n'invente pas de critère : il va dans « Points non déterminés » (« signalé par Lighthouse, critère RGAA non déterminé »).

### Performance

- **Image lourde servie telle quelle** : la commande 4 liste les fichiers image de plus de 200 Ko (200 000 octets) des dossiers `public/`, `static/` et `assets/`, avec leur taille en octets. Pour chacun qui appartient à un front audité, un constat de performance cite son chemin et sa taille (ex. « 312 456 octets, soit 312 Ko »). Une image qui appartient à une application exclue (Flutter, stack non couverte) n'est pas reprise.
- Autres constats permis s'ils se lisent dans le code : image sans dimensions (`width` et `height`), image hors de l'écran initial sans `loading="lazy"`, police ou script tiers bloquant dans le document racine.
- **Mode code seul** : aucun score ni aucune métrique, ni nom ni valeur (score Lighthouse, LCP, CLS, INP, FCP, TBT, temps de chargement, durées en secondes ou millisecondes), nulle part dans l'audit, sauf la phrase de la Synthèse qui dit qu'ils n'ont pas été mesurés.
- **Mode code + URL** : les audits de performance de Lighthouse en échec deviennent des constats, avec leur valeur mesurée (`displayValue`).

### Référencement

- Page ou route sans titre : constat de référencement, en plus du constat RGAA 8.5, avec la route et le fichier.
- Page ou route sans meta description (`<meta name="description">`, `metadata.description`, `useHead`…) : constat de référencement seul, avec la route et le fichier (pas de constat RGAA).
- En mode URL, les audits SEO de Lighthouse en échec.

### Bonnes pratiques

- Document racine sans `<!doctype html>`, sans `<meta charset>` ou sans `<meta name="viewport">` ; balise obsolète (`<center>`, `<font>`, `<marquee>`) ; `document.write`.
- En mode URL, les audits « Best Practices » de Lighthouse en échec, repris tels quels (y compris ceux de sécurité, sans analyse).

### Problèmes signalés par Lighthouse (mode code + URL)

Pour chaque audit en échec du résumé (`issues`) :
- s'il recoupe un constat du code (même problème, même élément), fusionne-les en un seul constat qui cite le fichier et la ligne, et précise « confirmé par Lighthouse » ;
- sinon, s'il est rattachable à un fichier du projet (ex. une ressource `https://<hôte>/medias/photo.webp` présente dans un dossier `public/` du front, retrouvée avec Glob ; un extrait HTML retrouvé avec Grep puis lu), le constat cite ce fichier ;
- sinon, le constat cite l'URL auditée (ou celle de la ressource) et porte la mention « non rattaché au code ».

### Points que le code ne peut établir

Ce qui dépend de l'hébergeur ou du serveur (compression gzip ou brotli, cache HTTP, HTTP/2, CDN, redirections côté serveur) n'est jamais affirmé ailleurs que dans « Points non déterminés », sauf si un fichier de configuration du dépôt le fixe (ex. `nginx.conf`, `vercel.json`, `netlify.toml`), cité alors comme source. Une recommandation peut en parler au conditionnel (« vérifier que… »).

## Constats : format, niveaux, identifiants

Chaque constat est une sous-section `###` de sa catégorie, sous la forme du modèle :

- **Identifiant** : W1, W2… dans le titre.
- **Niveau** :
  - **élevé** : empêche ou gêne fortement un usage ou l'indexation : champ sans libellé, image sans alternative, page sans titre, image de plus de 1 Mo (1 000 000 octets), audit Lighthouse de score inférieur à 0,5 dans une catégorie dont le score est inférieur à 50 ;
  - **moyen** : langue non déclarée, meta description absente, image de 200 Ko à 1 Mo, autre audit Lighthouse de score inférieur à 0,5 ;
  - **faible** : tout autre constat.
- **Application** : le nom et le dossier du front concerné, dès que plusieurs fronts sont audités.
- **Emplacement** : au moins un fichier et numéro de ligne (`chemin`, ligne N) ; un fichier entier sans ligne seulement quand le constat porte sur le fichier lui-même (ex. une image trop lourde) ; à défaut de fichier, l'URL de la page concernée avec « non rattaché au code ».
- **Constat** : description factuelle, avec la route quand elle compte.
- **Recommandation** : l'action de correction, sans estimation de charge.

**Identifiants stables** :
- Premier audit : numérote dans l'ordre des sections (Performance, Accessibilité, Référencement, Bonnes pratiques), à partir de W1.
- Relance : un constat encore présent (même problème, même fichier ou même URL, même critère ; la ligne peut avoir bougé) garde son identifiant. Un constat corrigé est retiré, sans être mentionné. Un nouveau constat prend le numéro qui suit le plus grand identifiant jamais attribué, c'est-à-dire le plus grand entre la ligne « Dernier identifiant attribué » de l'ancien audit et les identifiants qu'il contient. Un identifiant retiré n'est jamais réattribué.
- La ligne « Dernier identifiant attribué : W<n> » de l'en-tête donne le plus grand identifiant jamais attribué, retirés compris (elle reste inchangée si aucun constat n'est ajouté).

## Modèle du livrable

Titres de section en `##`, exactement dans cet ordre, sans table des matières. Une section sans constat contient « Aucun constat. ».

```markdown
# Audit web de <nom du projet>

Outil : wf-audit-web · Date : AAAA-MM-JJ · Commit : <sha court ou « hors git »>[ · modifications non commitées]
Dernier identifiant attribué : W<n>

## Synthèse

<En mode code seul : « Audit établi par lecture du code : la performance réelle n'a pas été mesurée (aucun score ni aucune métrique). »>
<En mode code + URL : tableau des scores Lighthouse sur 100 (Performance, Accessibilité, Bonnes pratiques, Référencement) de l'URL auditée, avec la version de Lighthouse, le profil d'appareil mobile et l'heure de la mesure (AAAA-MM-JJ HH:MM UTC).>

| Catégorie | Élevé | Moyen | Faible | Total |
|---|---|---|---|---|
| Performance | n | n | n | n |
| Accessibilité | n | n | n | n |
| Référencement | n | n | n | n |
| Bonnes pratiques | n | n | n | n |

<Deux ou trois phrases sur les priorités.>

Cet audit ne vaut pas audit de conformité RGAA : il relève des défauts repérables dans le code[ et par Lighthouse], sans tests manuels, sans lecteur d'écran ni taux de conformité.

## Périmètre et méthode

- Mode : <code seul | code + URL>[ ; URL demandée : <URL> ; URL auditée : <URL finale>[ (redirection)]][ ; mesure impossible : <cause>].
- Référentiel d'accessibilité : RGAA 4.1.
- Applications auditées : <nom> (`<dossier>`)…
- Exclues : <nom> (`<dossier>`) : application mobile, cible web Flutter non couverte en v1.
- Non couvert : <nom> (`<dossier>`) : <stack> non couverte en v1, aucun constat rapporté.
- Dossiers analysés : `<dossier>`…
- Mesure : <« aucune (mode code seul) » ou « Lighthouse <version>, profil mobile, AAAA-MM-JJ HH:MM UTC, une seule page »>.

## Performance

### W<n> — <Titre court>

- Niveau : <élevé | moyen | faible>
- Application : <nom> (`<dossier>`)
- Emplacement : `<chemin>`, ligne <N>
- Constat : <description factuelle>
- Recommandation : <action>

## Accessibilité

### W<n> — <Titre court>

- Niveau : <élevé | moyen | faible>
- Critère : RGAA <n.m> (WCAG <x.y.z>)
- Application : <nom> (`<dossier>`)
- Emplacement : `<chemin>`, ligne <N>
- Constat : <description factuelle>
- Recommandation : <action>

## Référencement

## Bonnes pratiques

## Plan d'action

1. W<n> (élevé, <catégorie>) : <action en une ligne>
2. W<n> (moyen, <catégorie>) : <action en une ligne>
3. W<n> (faible, <catégorie>) : <action en une ligne>

## Points non déterminés

- <Point, avec les fichiers concernés.>
```

**Synthèse** : en mode URL avec mesure, l'heure vient de `fetchTime`, la version de `lighthouseVersion`, le profil de `formFactor`. En cas de redirection, une phrase précise que les scores portent sur l'URL finalement auditée (ex. une page de connexion), pas sur l'URL demandée. Les nombres du tableau correspondent exactement aux constats des quatre sections.

**Périmètre et méthode** : en mode URL, l'URL demandée et l'URL finalement auditée figurent toutes les deux, même identiques.

**Plan d'action** : tous les constats, par leur identifiant, triés par niveau (tous les « élevé », puis les « moyen », puis les « faible ») et, à niveau égal, par identifiant. Aucune estimation en jours ni en heures.

**Points non déterminés** : liste à puces de ce qui n'a pas pu être établi : configuration de l'hébergeur (compression, cache HTTP, HTTP/2, CDN), mesure non faite et sa cause (Lighthouse absent avec la commande `npm install -g lighthouse` à lancer, URL injoignable, argument écarté), dossiers non lus, attributs venant d'une décomposition, composants de bibliothèque non vérifiables, audits Lighthouse sans critère RGAA. S'il n'y a rien : « - Aucun. »

## Fin

Écris l'audit avec Write dans `docs/wf/audit-web.md`, puis termine par un message court : chemin du livrable, création ou mise à jour, mode utilisé, nombre de constats par niveau et nombre de points non déterminés.
