---
name: wf-publication-store
description: Génère ou met à jour docs/wf/publication-store.md, la liste de ce qui est prêt et de ce qui manque avant de soumettre une application Flutter sur l'App Store et Google Play (identité, checklists iOS et Android, fiches store en français, étapes hors projet, verdict « prêt à soumettre » ou « non prêt »). À utiliser avec /wf-publication-store, ou quand on demande si une application mobile est prête à être publiée sur les stores.
---

# wf-publication-store

Tu prépares, en français, la soumission d'une application mobile Flutter sur l'App Store et sur Google Play, pour le projet ouvert dans le répertoire courant (le projet cible). Le livrable répond à « cette version est-elle prête à être soumise, et sinon qu'est-ce qui bloque ? ». Il s'appuie sur les fichiers du projet et sur la documentation officielle publique des stores ; l'état des consoles (App Store Connect, Google Play Console) n'est pas accessible et tu ne t'y connectes jamais.

## Règles absolues

- **Écriture** : un seul fichier, `docs/wf/publication-store.md`, écrit avec l'outil Write (qui crée `docs/wf/` au besoin ; pas de `mkdir`). Aucun autre fichier du projet n'est créé, modifié, déplacé ou supprimé : ni la version ni le numéro de build (`pubspec.yaml`, `Info.plist`, `build.gradle`), ni les métadonnées de store (`fastlane/metadata/`), ni le livrable de `wf-release-notes`, qui est seulement lu.
- **Aucune exécution** : tu ne lances ni build, ni signature, ni téléversement, ni le projet, ni aucun de ses outils (flutter, dart, xcodebuild, gradle, fastlane, pod…). Bash ne sert qu'à ces quatre commandes, recopiées telles quelles, chacune seule (sans option ajoutée, redirection, variable, sous-shell ni enchaînement) :
  - `git rev-parse --short HEAD`
  - `git status --porcelain`
  - `git ls-files -- '*key.properties' '*.jks' '*.keystore' '*.p12' '*.p8'`
  - `date +%F`

  Aucune autre commande Bash, même en lecture (`ls`, `cat`, `find`, `curl`…). Pour lire, utilise Read, Glob et Grep.
- **Secrets** :
  - Ne lis jamais, ni avec Read, ni avec Grep, ni avec Bash, un fichier d'environnement (`.env`, `.env.local`, `.env.production`…, sauf `.env.example`).
  - Fichiers de signature et de configuration sensibles : `key.properties`, `*.jks`, `*.keystore`, `*.p12`, `*.p8`, `*.mobileprovision`, `GoogleService-Info.plist`, `google-services.json`, `firebase_options.dart` (configuration FlutterFire, sous `lib/`). Tu repères leur présence avec Glob, tu ne les ouvres jamais (ni Read, ni Grep), et le livrable indique seulement leur présence et leur chemin, sans aucune valeur.
  - Avec Grep, passe toujours le paramètre `glob` limité à `*.{dart,gradle,kts,xml,pbxproj,xcconfig}` et le mode `output_mode: "files_with_matches"`, qui ne liste que des noms de fichiers : jamais de Grep sans `glob` ni en mode contenu, ni sur des fichiers `.json`, `.plist`, `.properties` ou `.txt`. Lis ensuite avec Read les fichiers trouvés qui ne sont pas sensibles (jamais `firebase_options.dart`).
  - Un mot de passe, une clé ou un jeton écrit en clair dans un fichier lu (ex. `storePassword` dans `build.gradle`) n'est jamais recopié : cite le fichier et la ligne, pas la valeur.
- **Données personnelles** : aucune adresse e-mail (de contributeur, de support ou autre) dans le livrable.
- **Honnêteté** : chaque affirmation s'appuie sur un fichier lu, dont le chemin (relatif à la racine du projet, dossier de l'application compris) est cité. Ce qui n'a pas pu être établi est écrit « non déterminé », jamais deviné. Une exigence des stores n'est jamais affirmée de mémoire : seulement la valeur relevée dans le projet et le lien officiel (voir « Exigences qui évoluent »).
- **Périmètre** : ni revue de sécurité (c'est `wf-revue-securite`, sauf l'alerte de l'étape 4), ni mise à jour du framework ou des dépendances (c'est `wf-montee-version`), ni rédaction des notes de version (c'est `wf-release-notes`), ni production de captures ou de visuels.

## Étape 1 : trouver les applications Flutter

Avec Glob, cherche les `pubspec.yaml` du projet (racine et sous-dossiers), hors `build/`, `.dart_tool/`, `.symlinks/`, `Pods/`, `node_modules/`. Lis chacun avec Read. Une **application Flutter** est un dossier dont le `pubspec.yaml` déclare la dépendance `flutter` (`flutter:` suivi de `sdk: flutter` sous `dependencies:`) et qui contient un dossier `ios/` ou `android/`. Un paquet Dart ou un plugin sans `ios/` ni `android/` n'en est pas une. Toute autre application du projet (application web, API) est ignorée : elle n'apparaît ni dans l'identité, ni dans les checklists, ni dans les fiches.

S'il n'y a aucune application Flutter, détermine ce que contient le projet, sans rien écrire et sans créer de dossier :

- application mobile d'une autre technologie, repérée par ses fichiers (Glob ne renvoie que des fichiers, jamais des dossiers : un projet Xcode se repère par `**/*.xcodeproj/project.pbxproj` ou `**/*.xcworkspace/contents.xcworkspacedata`, complété par `**/*.swift`) :
  - `package.json` qui dépend de `expo` : **Expo** ;
  - `package.json` qui dépend de `react-native` (sans `expo`) : **React Native** ;
  - projet Xcode (`*.xcodeproj`, `*.xcworkspace`) sans application Flutter ni JavaScript : **iOS natif (Swift/Xcode)** ;
  - `build.gradle` ou `build.gradle.kts` qui applique `com.android.application`, sans application Flutter ni JavaScript : **Android natif (Kotlin/Gradle)** ;
  - autre framework mobile reconnaissable (Capacitor, Ionic, .NET MAUI, Kotlin Multiplatform…) : son nom.

  Termine alors par ce message, en nommant chaque framework trouvé : « <framework> non couvert en v1 : aucun livrable n'a été écrit. » (ex. « React Native non couvert en v1 : aucun livrable n'a été écrit. »).
- aucune application mobile (projet web, API, bibliothèque, répertoire vide) : termine par ce message : « Aucune application mobile trouvée dans ce projet : aucun livrable n'a été écrit. »

Si le projet contient à la fois une ou plusieurs applications Flutter et une application mobile d'une autre technologie, analyse les applications Flutter et cite l'autre dans « Points non déterminés » (« <framework> non couvert en v1 (`<dossier>`) »).

Nomme chaque application Flutter par le champ `name` de son `pubspec.yaml`, toujours suivi de son dossier (ex. « mon_app (`apps/client`) »). Avec plusieurs applications, chaque section du livrable (Identité de l'application, Checklist iOS, Checklist Android, Fiches store, Étapes hors projet) contient une sous-section `### <nom> (`<dossier>`)` par application, dans le même ordre, et la Synthèse donne un verdict par application. Avec une seule application, pas de sous-section par application.

## Étape 2 : préparer l'en-tête

- Commit : `git rev-parse --short HEAD`. Si la commande échoue (pas un dépôt git, ou dépôt sans commit), écris « hors git » et ne lance ni `git status --porcelain` ni `git ls-files`.
- Sinon, `git status --porcelain` : si la sortie contient au moins une ligne qui ne concerne pas `docs/wf/publication-store.md`, ajoute la mention « modifications non commitées ». Sinon, ne l'écris pas.
- Date : `date +%F` (format AAAA-MM-JJ).

## Étape 3 : livrable existant et notes de version

- Si `docs/wf/publication-store.md` existe, lis-le d'abord. Tu le réécriras en entier avec Write : un seul livrable dans le fichier (jamais l'ancien suivi du nouveau), en conservant ce qui reste vrai d'après les fichiers actuels, en corrigeant ce qui a changé (versions, statuts, chemins) et en mettant à jour la date, le commit et la mention de l'en-tête. Ne crée aucun autre fichier (pas de copie datée ni numérotée).
- Si `docs/wf/release-notes.md` existe (livrable de `wf-release-notes`), lis-le sans le modifier. Son contrat : une section `## Version <numéro> (<AAAA-MM-JJ>)` par version, la plus récente en tête, chacune avec des sous-sections `### Nouveautés`, `### Améliorations`, `### Corrections`, `### Points d'attention`, `### Références`, `### Points non déterminés` ; une sous-section sans entrée est omise. Seule compte la première section `## Version`, et dans celle-ci seulement la sous-section « Nouveautés ».

## Étape 4 : fichiers sensibles

- Avec Glob, repère dans chaque application les fichiers sensibles : `**/key.properties`, `**/*.jks`, `**/*.keystore`, `**/*.p12`, `**/*.p8`, `**/*.mobileprovision`, `**/GoogleService-Info.plist`, `**/google-services.json`, `**/firebase_options.dart`. Ne les ouvre pas.
- Si le projet est un dépôt git, lance `git ls-files -- '*key.properties' '*.jks' '*.keystore' '*.p12' '*.p8'`. Chaque fichier de clés listé est suivi par git : la Synthèse le signale comme alerte, avec son chemin, et renvoie à `/wf-revue-securite`. Les fichiers `*.mobileprovision`, `GoogleService-Info.plist`, `google-services.json` et `firebase_options.dart` ne déclenchent pas cette alerte.

## Étape 5 : lire l'application

Pour chaque application Flutter, lis avec Read (chemins relatifs au dossier de l'application) :

- `pubspec.yaml` : `version: X.Y.Z+N` (numéro de version `X.Y.Z`, numéro de build `N`) et dépendances (plugins qui touchent aux permissions : appareil photo, photothèque, localisation, micro, contacts, notifications…).
- iOS, si `ios/` existe : `ios/Runner/Info.plist` ; `ios/Runner.xcodeproj/project.pbxproj` (`PRODUCT_BUNDLE_IDENTIFIER`, `IPHONEOS_DEPLOYMENT_TARGET`, `DEVELOPMENT_TEAM`) et `ios/Podfile` (`platform :ios`) s'ils existent ; présence de `ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json` (et de l'image 1024×1024 qu'il référence) et de `ios/Runner/PrivacyInfo.xcprivacy`, avec Glob.
- Android, si `android/` existe : `android/app/build.gradle` ou `android/app/build.gradle.kts` (`applicationId`, `minSdk`/`minSdkVersion`, `targetSdk`/`targetSdkVersion`, `signingConfigs`, `buildTypes`), `android/app/src/main/AndroidManifest.xml` (`android:label`, `android:icon`, `uses-permission`), `android/app/src/main/res/values/strings.xml` si le libellé y renvoie, `android/gradle.properties` s'il existe ; présence des icônes de lanceur `android/app/src/main/res/mipmap-*/` avec Glob.
- Le code Dart (`lib/`) avec Grep (`glob` `*.{dart,gradle,kts,xml,pbxproj,xcconfig}`, mode `files_with_matches`), puis Read des fichiers trouvés hors fichiers sensibles, pour repérer l'usage des fonctionnalités protégées et un écran ou service de connexion.
- Les métadonnées de store, avec Glob : `**/fastlane/metadata/**` sous le dossier de l'application.
- Pour le brouillon de fiche : `README.md` de l'application et de la racine, et la documentation du projet (`docs/`, hors `docs/wf/`).

## Modèle du livrable

Titres de section en `##`, exactement dans cet ordre, sans table des matières. Sous-sections en `###` (et `####` sous une sous-section d'application).

```markdown
# Préparation de la publication sur les stores de <nom du projet>

Outil : wf-publication-store · Date : AAAA-MM-JJ · Commit : <sha court ou « hors git »>[ · modifications non commitées]

## Synthèse

- **<verdict : prêt à soumettre | non prêt>**[ (<nom> (`<dossier>`))] — iOS : <n> élément(s) bloquant(s) « à faire », <m> « à vérifier » ; Android : <n> élément(s) bloquant(s) « à faire », <m> « à vérifier ».
- **Alerte** : fichier de clés suivi par git : `<chemin>` ; le retirer du dépôt et lancer `/wf-revue-securite`.

## Identité de l'application

| Information | iOS | Android |
|---|---|---|
| Nom affiché | <valeur> (`<fichier>`, `<clé>`) | <valeur> (`<fichier>`, `<clé>`) |
| Identifiant | <bundle identifier> (`<fichier>`) | <applicationId> (`<fichier>`) |
| Numéro de version | <X.Y.Z> (`<fichier>`, `version: X.Y.Z+N`) | <X.Y.Z> (`<fichier>`) |
| Numéro de build | <N> (`<fichier>`) | <N> (`<fichier>`) |

## Checklist iOS

| Élément | Statut | Bloquant | Fichier | Détail |
|---|---|---|---|---|
| <élément> | <OK | à faire | à vérifier | non applicable> | <oui | non> | `<fichier lu ou chemin cherché>` | <constat, ligne, valeur relevée> |

## Checklist Android

| Élément | Statut | Bloquant | Fichier | Détail |
|---|---|---|---|---|
| <élément> | <statut> | <oui | non> | `<fichier lu ou chemin cherché>` | <constat> |

## Fiches store

### iOS

- Nom : « <texte> » (`<fichier>`) — <n> caractères / limite 30
- Sous-titre : « <texte> » (`<fichier>`) — <n> caractères / limite 30
- Mots-clés : « <texte> » (`<fichier>`) — <n> caractères / limite 100
- Description complète (`<fichier>`) — <n> caractères / limite 4000 :

  > <texte>

### Android

- Nom : « <texte> » (`<fichier>`) — <n> caractères / limite 30
- Description courte : « <texte> » (`<fichier>`) — <n> caractères / limite 80[ — dépasse la limite]
- Description complète (`<fichier>`) — <n> caractères / limite 4000 :

  > <texte>

### Nouveautés de cette version

Source : `<titre de la section de version>` de `docs/wf/release-notes.md`.

> <contenu de la sous-section « Nouveautés », recopié>

Nouveautés iOS : <n> caractères / limite 4000 ; nouveautés Android : <n> caractères / limite 500.

## Étapes hors projet

| Élément | Statut | Plateforme | Détail |
|---|---|---|---|
| <élément> | à vérifier | <iOS, Android> | <ce qu'il faut faire dans la console, avec les fichiers du projet concernés> |

## Points non déterminés

- <Point, avec les fichiers concernés.>
```

## Remplir chaque section

**Synthèse** : par application, le verdict « prêt à soumettre » si aucun élément bloquant (colonne Bloquant à « oui ») n'a le statut « à faire » dans ses deux checklists, « non prêt » sinon ; puis, par plateforme, le nombre d'éléments bloquants « à faire » et le nombre d'éléments « à vérifier », comptés sur les lignes de la checklist de cette plateforme (une plateforme absente : « iOS : non applicable »). Les décomptes correspondent exactement aux tableaux. Ensuite, une ligne **Alerte** par fichier de clés suivi par git (étape 4), avec son chemin et le renvoi à `/wf-revue-securite`. Rien d'autre : le détail est dans les checklists.

**Identité de l'application** : pour chaque plateforme présente, le nom affiché, l'identifiant, le numéro de version et le numéro de build, chacun avec le fichier d'où il provient. Une plateforme absente (pas de dossier `ios/` ou `android/`) : « non applicable » dans sa colonne.
- Nom affiché iOS : `CFBundleDisplayName` de l'`Info.plist`, à défaut `CFBundleName`. Nom affiché Android : `android:label` du manifeste (s'il renvoie à `@string/…`, la valeur de `res/values/strings.xml`).
- Identifiant iOS (bundle identifier) : `CFBundleIdentifier` de l'`Info.plist` ; s'il vaut `$(PRODUCT_BUNDLE_IDENTIFIER)`, la valeur de `PRODUCT_BUNDLE_IDENTIFIER` dans `project.pbxproj` (configuration Release). Identifiant Android : `applicationId` de `build.gradle` ou `build.gradle.kts`.
- Version et build : quand l'`Info.plist` et `build.gradle` ne les fixent pas eux-mêmes mais renvoient à des variables fournies par le build Flutter, ils viennent de la ligne `version:` du `pubspec.yaml` (ex. `version: 1.4.0+27` : version 1.4.0, build 27) ; cite le `pubspec.yaml`. Une valeur écrite en dur dans un fichier natif prime pour sa plateforme : cite ce fichier, et signale l'écart avec le `pubspec.yaml` dans « Points non déterminés ».
- Une valeur introuvable ou non résolue (variable dont la définition n'est pas lisible) porte la mention « non déterminé », avec le fichier cherché.

**Checklist iOS** et **Checklist Android** : un tableau par plateforme (par application s'il y en a plusieurs), aux colonnes exactes `| Élément | Statut | Bloquant | Fichier | Détail |`.
- Statut : uniquement OK, à faire, à vérifier ou non applicable. Bloquant : « oui » si l'élément empêche la soumission ou entraîne un rejet tant qu'il n'est pas réglé, « non » sinon.
- Fichier : le fichier lu ; en cas d'absence, le chemin cherché (ex. `<dossier>/ios/Runner/PrivacyInfo.xcprivacy`). Jamais vide.
- Détail : le constat, avec la ligne quand elle est utile et la valeur relevée (sauf valeur sensible).
- Sans dossier `ios/` (ou `android/`), la checklist de cette plateforme contient seulement : « non applicable : pas de dossier `ios/` » (ou `android/`), sans tableau ni erreur.

Éléments de la **Checklist iOS**, au moins :
- **Icône 1024×1024** : `AppIcon.appiconset/Contents.json` présent et référençant une image 1024×1024 (taille `1024x1024`) qui existe : OK, non. Absent ou sans image 1024×1024 : à faire, oui.
- **Descriptions d'usage des permissions** : une ligne par clé `NS*UsageDescription` de l'`Info.plist`, nommée par la clé. Valeur non vide : OK, non. Clé présente avec une valeur vide : à faire, oui. Si le code Dart ou un plugin du `pubspec.yaml` utilise une fonctionnalité protégée (appareil photo, photothèque, localisation, micro, contacts…) dont la clé est absente de l'`Info.plist` : une ligne à faire, oui, qui cite dans Détail le fichier Dart et la ligne d'usage.
- **Cible de déploiement minimale** : `IPHONEOS_DEPLOYMENT_TARGET` (`project.pbxproj`) ou `platform :ios` (`Podfile`) : OK, non, avec la valeur. Introuvable : à vérifier, non, « non déterminé ».
- **Équipe de signature** : `DEVELOPMENT_TEAM` dans `project.pbxproj`. Renseignée : OK, non (l'identifiant d'équipe n'a pas à être recopié). `project.pbxproj` lu mais clé absente ou vide : à faire, oui. `project.pbxproj` absent : à vérifier, oui, « non déterminé », avec le chemin cherché.
- **Manifeste de confidentialité** : `ios/Runner/PrivacyInfo.xcprivacy` présent : OK, non. Absent : à faire, oui.
- **SDK iOS et Xcode de build** : exigence qui évolue (voir plus bas).
- **Fichiers sensibles** (seulement s'il y en a sous `ios/`) : présence de chacun, « présent, non lu ». Un fichier de clés suivi par git : à faire, non, avec renvoi à l'alerte de la Synthèse ; sinon OK, non.

Éléments de la **Checklist Android**, au moins :
- **Icônes de lanceur** : l'icône nommée par `android:icon` existe dans les dossiers `res/mipmap-*` : OK, non. Absente : à faire, oui (Fichier : le chemin `mipmap-*` cherché).
- **Permissions déclarées** : une ligne par `uses-permission` du manifeste, nommée par la permission. Permission normale (ex. accès à Internet) : OK, non. Permission sensible (localisation, appareil photo, micro, contacts, stockage, SMS, journal d'appels, localisation en arrière-plan…) : à vérifier, non, « à déclarer de façon cohérente dans Data safety ». Aucune : une ligne « aucune permission déclarée », OK, non.
- **minSdk** : valeur de `minSdk`/`minSdkVersion` : OK, non. Renvoi à `flutter.minSdkVersion` : à vérifier, non, « fixé par le SDK Flutter : non déterminé ».
- **targetSdk** : exigence qui évolue (voir plus bas).
- **Configuration de signature du type de build `release`** (élément « configuration de signature ») :
  - `release` signé avec `signingConfigs.debug`, ou sans `signingConfig` : à faire, oui ; Détail cite la ligne et nomme le cas (« signé avec la configuration `signingConfigs.debug` » ou « aucune configuration de signature »).
  - `release` signé par une configuration dédiée qui lit ses valeurs dans `key.properties` ou dans des variables : OK, non ; la présence ou l'absence de `key.properties` est indiquée sans le lire.
  - Mot de passe écrit en clair dans un fichier de build (`storePassword`, `keyPassword` affectés à une chaîne littérale dans `build.gradle`, `build.gradle.kts` ou `gradle.properties`) : à faire, avec le fichier et la ligne de chaque mot de passe (ex. « `storePassword` en clair, `<fichier>` l. 12 ; valeur non recopiée »), jamais la valeur. Bloquant : non si la signature est par ailleurs correcte (un mot de passe en clair n'empêche pas la soumission), oui si elle relève aussi du premier cas.
- **Fichiers sensibles** (seulement s'il y en a sous `android/`, ou un `firebase_options.dart` sous `lib/`) : comme pour iOS.

**Exigences qui évoluent** : le niveau minimal de `targetSdk` exigé par Google Play et la version minimale du SDK iOS ou de Xcode exigée par Apple changent avec le temps.
- Ligne « targetSdk » (Checklist Android) : à vérifier, oui, la valeur relevée (`targetSdk`/`targetSdkVersion`, ou « non déterminé » si elle renvoie à `flutter.targetSdkVersion`) et le lien `https://developer.android.com/google/play/requirements/target-sdk`.
- Ligne « SDK iOS et Xcode de build » (Checklist iOS) : à vérifier, oui, la valeur relevée dans le projet (fichier `.xcode-version`, version de Xcode fixée par la CI) ou « non déterminé », et le lien `https://developer.apple.com/news/upcoming-requirements/`.
- Consulte ces deux pages avec WebFetch, sans rien envoyer du projet (seulement l'URL et une question générale sur l'exigence en vigueur). Si une page a pu être lue, ajoute dans Détail l'exigence qu'elle indique et « consulté le AAAA-MM-JJ », sans changer le statut. Si WebFetch est indisponible, refusé ou en échec, garde la valeur relevée et le lien, n'affirme aucune exigence de mémoire, poursuis sans t'interrompre, et écris dans « Points non déterminés » : « la documentation des stores n'a pas pu être consultée » avec les liens concernés.

**Fiches store** : en français uniquement (une sous-section par application s'il y en a plusieurs, avec `#### iOS`, `#### Android`, `#### Nouveautés de cette version`).
- Métadonnées présentes dans `fastlane/metadata/` (dossier de l'application, ou `ios/fastlane/` et `android/fastlane/`), en français (`fr-FR`, `fr-CA` ou `fr`) : reprends leurs textes tels quels en citant chaque fichier. iOS (fastlane deliver) : `metadata/<langue>/name.txt`, `subtitle.txt`, `keywords.txt`, `description.txt`. Android (fastlane supply) : `metadata/android/<langue>/title.txt`, `short_description.txt`, `full_description.txt`. Un champ dont le fichier manque : « non déterminé », avec le chemin cherché, repris dans « Points non déterminés ».
- Sinon (aucune métadonnée en français) : propose un brouillon en français, marqué « brouillon à valider », établi à partir du README et de la documentation du projet (fichiers cités) : nom, sous-titre iOS, mots-clés iOS, description courte Android, description complète. N'invente aucune fonctionnalité absente de ces fichiers.
- Nombre de caractères : à côté de chaque texte, repris ou proposé, écris « <n> caractères / limite <L> », en comptant tous les caractères (espaces, ponctuation et retours à la ligne compris, sans le retour à la ligne final du fichier). Limites : nom 30 (iOS et Android), sous-titre iOS 30, mots-clés iOS 100, description courte Android 80, description complète 4000, nouveautés iOS 4000, nouveautés Android 500. Un texte qui dépasse sa limite porte la mention « dépasse la limite ».
- **Nouveautés de cette version** :
  - `docs/wf/release-notes.md` absent : écris qu'aucune note de version n'est disponible et suggère de lancer `/wf-release-notes`. Aucun texte de nouveautés n'est rédigé.
  - Présent, et la section de version la plus récente contient une sous-section « Nouveautés » : recopie son contenu tel quel, en citant le titre de la section (ex. `## Version 1.4.0 (2026-03-02)`), puis les décomptes pour iOS (limite 4000) et Android (limite 500). Ne reprends rien des autres sous-sections ni des autres versions.
  - Présent, mais sans sous-section « Nouveautés » dans la section la plus récente : écris « texte de nouveautés à rédiger à la main », en citant le titre de la section ; aucun texte n'est rédigé ni repris d'une autre sous-section ; « Points non déterminés » le signale.
  - Numéro de la section la plus récente différent du numéro de version du `pubspec.yaml` sans le numéro de build (ex. `1.4.0` pour `version: 1.4.0+27`) : ajoute « à vérifier : notes de version <numéro des notes> pour l'application <numéro du pubspec> ». Numéros égaux : aucune mention.

**Étapes hors projet** : ce que l'outil ne peut pas vérifier depuis le projet, chaque élément au statut « à vérifier » (une sous-section par application s'il y en a plusieurs) :
- captures d'écran, pour chaque plateforme présente ;
- questionnaire de confidentialité (App Privacy pour iOS, Data safety pour Android) à remplir en cohérence avec les permissions relevées dans les checklists, en les nommant ;
- classification du contenu (classification par âge de l'App Store, questionnaire de classification de Google Play) ;
- compte de démonstration pour la revue : si l'application exige une connexion, cite le fichier qui le montre (écran ou service de connexion) ; sinon, écris qu'aucune connexion n'a été repérée.

**Points non déterminés** : liste à puces de tout ce qui n'a pas pu être établi (valeurs « non déterminé », documentation des stores non consultée, nouveautés à rédiger à la main, champs de fiche manquants, écarts de version entre fichiers, autre framework mobile non couvert), avec les fichiers concernés. S'il n'y a rien : « - Aucun. »

## Fin

Écris le livrable avec Write dans `docs/wf/publication-store.md`, puis termine par un message court : chemin du livrable, création ou mise à jour, verdict par application et nombre de points non déterminés.
