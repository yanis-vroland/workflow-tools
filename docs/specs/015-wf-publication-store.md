# Spec 015 : wf-publication-store, préparation d'une publication sur les stores mobiles

Statut : validée
Date : 2026-10-09

## Besoin

En tant que freelance qui publie une application mobile sur l'App Store ou Google Play, je veux obtenir, avant chaque soumission, la liste de ce qui est prêt et de ce qui manque dans le projet, afin d'éviter un rejet ou un aller-retour évitable avec la revue des stores.

Le livrable s'adresse à moi (ou au développeur qui soumet). Il répond à la question « cette version est-elle prête à être soumise, et sinon qu'est-ce qui bloque ? ». Il s'appuie sur les fichiers du projet et sur la documentation officielle publique des stores ; l'état des consoles (App Store Connect, Google Play Console) n'est pas accessible.

En v1, seules les applications Flutter (iOS et Android) sont couvertes. Les brouillons de fiches store restent dans le livrable, en français.

### Entrées de l'outil

- Les fichiers du projet Flutter (`pubspec.yaml`, `ios/`, `android/`, `fastlane/metadata/` s'il existe).
- Le livrable de `wf-release-notes` (spec 009), s'il existe : la sous-section « Nouveautés » de la section de version la plus récente (`## Version <numéro> (<AAAA-MM-JJ>)`, en tête) de `docs/wf/release-notes.md`. L'outil le lit sans le modifier.
- La documentation officielle publique des stores, pour les exigences qui évoluent, avec le repli hors réseau prévu par l'ADR-001.

Il suit les conventions de l'ADR-001 et de son amendement 1.

## Critères d'acceptation

- CA1 : Étant donné un projet Flutter, quand je lance `/wf-publication-store` à sa racine, alors le fichier `docs/wf/publication-store.md` est créé et aucun autre fichier du projet n'est modifié (en particulier, ni la version, ni le numéro de build, ni les métadonnées de store).
- CA2 : Étant donné le livrable produit, alors il contient dans cet ordre les sections : Synthèse, Identité de l'application, Checklist iOS, Checklist Android, Fiches store, Étapes hors projet, Points non déterminés.
- CA3 : Étant donné un projet dont l'application Flutter se trouve dans un sous-dossier (ex. FieldOps : application web à la racine et application compagnon dans un sous-dossier), alors l'outil trouve le `pubspec.yaml` déclarant la dépendance `flutter`, analyse cette application, et ignore l'application web.
- CA4 : Étant donné un projet mobile React Native, Expo ou natif (Swift/Xcode, Kotlin/Gradle) sans application Flutter, quand je lance l'outil, alors il indique « <framework> non couvert en v1 » et n'écrit aucun livrable.
- CA5 : Étant donné un projet qui ne contient aucune application mobile, quand je lance l'outil, alors il l'indique et n'écrit aucun livrable.
- CA6 : Étant donné un projet Flutter, alors « Identité de l'application » donne, pour chaque plateforme présente, le nom affiché, l'identifiant (bundle identifier iOS, `applicationId` Android), le numéro de version et le numéro de build, chacun avec le fichier d'où il provient (ex. `version: 1.4.0+27` dans `pubspec.yaml`). Une valeur introuvable porte la mention « non déterminé ».
- CA7 : Étant donné le livrable, alors chaque élément des checklists est une ligne d'un tableau aux colonnes : Élément, Statut, Bloquant, Fichier, Détail. Les seuls statuts admis sont : OK, à faire, à vérifier, non applicable. La colonne Fichier cite le fichier lu, ou le chemin cherché en cas d'absence.
- CA8 : Étant donné un projet avec un dossier `ios/`, alors « Checklist iOS » contient au moins les éléments : icône 1024×1024 dans l'`AppIcon.appiconset`, descriptions d'usage des permissions (`NS*UsageDescription` de l'`Info.plist`), cible de déploiement minimale, équipe de signature (`DEVELOPMENT_TEAM`), manifeste de confidentialité (`PrivacyInfo.xcprivacy`).
- CA9 : Étant donné un projet avec un dossier `android/`, alors « Checklist Android » contient au moins les éléments : icônes de lanceur dans les dossiers `mipmap-*`, permissions déclarées (`uses-permission` du manifeste), `minSdk` et `targetSdk`, configuration de signature du type de build `release`.
- CA10 : Étant donné une clé `NS*UsageDescription` présente avec une valeur vide dans l'`Info.plist`, alors l'élément correspondant porte le statut « à faire » et est bloquant.
- CA11 : Étant donné un type de build Android `release` signé avec la configuration `debug`, ou sans configuration de signature, alors l'élément « configuration de signature » porte le statut « à faire » et est bloquant.
- CA12 : Étant donné un fichier de signature ou de configuration sensible (`key.properties`, `*.jks`, `*.keystore`, `*.p12`, `*.p8`, `*.mobileprovision`, `GoogleService-Info.plist`, `google-services.json`), alors le livrable n'en recopie aucune valeur et indique seulement sa présence. Les fichiers de clés (`key.properties`, `*.jks`, `*.keystore`, `*.p12`, `*.p8`) ne sont pas lus.
- CA13 : Étant donné un fichier de clés listé en CA12 suivi par git, alors la Synthèse le signale comme alerte, avec son chemin, et renvoie à `wf-revue-securite`.
- CA14 : Étant donné un mot de passe écrit en clair dans un fichier de build (ex. `storePassword` dans `build.gradle`), alors l'élément « configuration de signature » cite le fichier et la ligne, sans la valeur, et porte le statut « à faire ».
- CA15 : Étant donné une exigence des stores qui évolue dans le temps (niveau minimal de `targetSdk`, version minimale du SDK iOS ou de Xcode), alors l'élément porte le statut « à vérifier », la valeur relevée dans le projet et le lien vers la page officielle de l'exigence. Si la page a pu être lue, la colonne Détail cite l'exigence qu'elle indique et la date de consultation, sans changer le statut.
- CA16 : Étant donné un réseau indisponible, alors les éléments de CA15 portent la valeur relevée et le lien officiel, « Points non déterminés » signale que la documentation des stores n'a pas pu être consultée, et le livrable est produit.
- CA17 : Étant donné le livrable, alors la Synthèse indique « prêt à soumettre » si aucun élément bloquant n'a le statut « à faire », « non prêt » sinon, suivi du nombre d'éléments bloquants « à faire » et du nombre d'éléments « à vérifier » par plateforme.
- CA18 : Étant donné un projet qui contient des métadonnées de store (ex. `fastlane/metadata/`), alors « Fiches store » reprend leurs textes en français en citant les fichiers. Sinon, elle propose un brouillon en français (nom, sous-titre iOS, mots-clés iOS, description courte Android, description complète) établi à partir du README et de la documentation du projet, marqué « brouillon à valider ».
- CA19 : Étant donné un livrable `docs/wf/release-notes.md` présent, alors « Fiches store » reprend, sous « Nouveautés de cette version », le contenu de la sous-section « Nouveautés » de la section de version la plus récente, en citant son titre. Si cette section ne contient pas de sous-section « Nouveautés » (`wf-release-notes` omet une sous-section vide), la rubrique indique « texte de nouveautés à rédiger à la main », aucun texte n'est rédigé par l'outil, et « Points non déterminés » le signale.
- CA20 : Étant donné une section de version la plus récente de `docs/wf/release-notes.md` dont le numéro diffère du numéro de version du `pubspec.yaml` (sans le numéro de build), alors « Nouveautés de cette version » porte la mention « à vérifier : notes de version <numéro> pour l'application <numéro> ».
- CA21 : Étant donné un projet sans `docs/wf/release-notes.md`, alors « Nouveautés de cette version » l'indique et suggère de lancer `/wf-release-notes` ; aucun texte de nouveautés n'est rédigé.
- CA22 : Étant donné un texte de fiche (repris ou proposé), alors son nombre de caractères est indiqué à côté de la limite du store : nom 30 (iOS et Android), sous-titre iOS 30, mots-clés iOS 100, description courte Android 80, description complète 4000, nouveautés iOS 4000, nouveautés Android 500. Un texte qui dépasse sa limite porte la mention « dépasse la limite ».
- CA23 : Étant donné le livrable, alors « Étapes hors projet » liste ce que l'outil ne peut pas vérifier depuis le projet, chaque élément portant le statut « à vérifier » : captures d'écran, questionnaire de confidentialité (App Privacy, Data safety) à remplir en cohérence avec les permissions relevées en CA8 et CA9, classification du contenu, compte de démonstration pour la revue si l'application exige une connexion.
- CA24 : Étant donné un projet Flutter qui ne contient qu'une plateforme (ex. pas de dossier `ios/`), alors la checklist de l'autre plateforme indique « non applicable », sans erreur.
- CA25 : Étant donné un projet qui contient plusieurs applications Flutter, alors « Identité de l'application », les checklists et « Fiches store » contiennent une sous-section par application, et la Synthèse donne un verdict par application.
- CA26 : Étant donné le livrable, alors son en-tête est conforme à l'ADR-001 (outil, date, commit ou « hors git », mention « modifications non commitées » le cas échéant), et un livrable déjà présent est mis à jour selon l'ADR-001 au lieu d'être dupliqué.
- CA27 : Étant donné un projet contenant un fichier `.env*` autre que `.env.example`, alors l'outil ne lit pas ce fichier et le livrable ne contient aucune de ses valeurs.

## Cas limites et erreurs

Couverts par CA4, CA5, CA6 (valeur introuvable), CA10, CA11, CA13, CA14, CA16, CA19 à CA22 (release notes absentes ou divergentes, texte trop long), CA24 et CA25.

## Hors périmètre

- Applications React Native, Expo et natives en v1 (détectées et signalées par CA4).
- Build, signature, téléversement ou soumission de l'application ; modification de la version ou du numéro de build.
- Accès aux consoles des stores ou à leurs API (exige des identifiants).
- Écriture dans `fastlane/metadata/` ou tout autre fichier hors de `docs/wf/`.
- Rédaction des notes de version (c'est `wf-release-notes`) : l'outil reprend leur « Nouveautés » sans les réécrire.
- Fiches store dans une autre langue que le français.
- Revue de sécurité des secrets ou de l'application (c'est `wf-revue-securite`) : ici, seulement l'alerte de CA13.
- Mise à jour du framework Flutter, du SDK Dart et des dépendances (c'est `wf-montee-version`) ; la montée des SDK natifs (`targetSdk`, Gradle, CocoaPods) n'est couverte par aucun outil en v1 (prévue pour `wf-montee-version` après la v1) : l'outil en signale seulement les exigences (CA15).
- Production des captures d'écran et des visuels de fiche.

## Questions ouvertes

- Aucune.

## Amendement 1 (validé)

Précisions issues de l'implémentation, validées. Chacune complète le CA indiqué.

- CA1 : l'outil n'exécute aucune commande du projet ni de son outillage (build, signature, outils Flutter, Xcode, Gradle, fastlane) ; Bash ne sert qu'à quatre commandes fixes, sans texte venu du projet : `git rev-parse --short HEAD`, `git status --porcelain`, `git ls-files -- '*key.properties' '*.jks' '*.keystore' '*.p12' '*.p8'` et `date +%F`.
- CA3 : une application Flutter est un dossier dont le `pubspec.yaml` déclare la dépendance `flutter` et qui contient un dossier `ios/` ou `android/` ; un paquet ou un plugin sans ces dossiers n'est pas analysé.
- CA3 : chaque application est nommée par le champ `name` de son `pubspec.yaml`, suivi de son dossier.
- CA4 : le framework est reconnu par ses fichiers et nommé « Expo » (dépendance `expo`, prioritaire), « React Native » (dépendance `react-native` sans `expo`), « iOS natif (Swift/Xcode) » (projet Xcode sans Flutter ni JavaScript) ou « Android natif (Kotlin/Gradle) » (module `com.android.application` sans Flutter ni JavaScript) ; le message est « <framework> non couvert en v1 : aucun livrable n'a été écrit. ».
- CA4 : un projet qui contient à la fois une application Flutter et une application mobile d'une autre technologie est analysé pour la partie Flutter, et « Points non déterminés » cite l'autre comme « <framework> non couvert en v1 », avec son dossier.
- CA5 : le message est « Aucune application mobile trouvée dans ce projet : aucun livrable n'a été écrit. ».
- CA6 : quand les fichiers natifs renvoient aux variables du build Flutter, la version et le build viennent du `pubspec.yaml` ; une valeur écrite en dur dans un fichier natif prime pour sa plateforme, ce fichier est cité et l'écart avec le `pubspec.yaml` figure dans « Points non déterminés ».
- CA6 : une plateforme absente porte « non applicable » dans l'identité.
- CA7 : la colonne Bloquant vaut « oui » (l'élément empêche la soumission ou entraîne un rejet tant qu'il n'est pas réglé) ou « non » ; la colonne Fichier n'est jamais vide.
- CA8 : une fonctionnalité protégée (appareil photo, photothèque, localisation, micro, contacts…) utilisée par le code ou un plugin sans sa clé `NS*UsageDescription` dans l'`Info.plist` donne une ligne « à faire », bloquante, qui cite le fichier et la ligne d'usage.
- CA8 : statuts des éléments iOS : icône 1024×1024 absente « à faire », bloquant ; manifeste de confidentialité absent « à faire », bloquant ; cible de déploiement introuvable « à vérifier », non bloquant ; équipe de signature « à faire », bloquant, si `project.pbxproj` est lu sans `DEVELOPMENT_TEAM`, et « à vérifier », bloquant, si `project.pbxproj` est absent ; l'identifiant d'équipe n'est pas recopié.
- CA9 : une ligne par permission déclarée ; une permission sensible (localisation, appareil photo, micro, contacts, stockage, SMS, journal d'appels…) porte « à vérifier », non bloquant, à déclarer dans Data safety ; une permission normale porte « OK ».
- CA9 : icônes de lanceur absentes : « à faire », bloquant ; `minSdk` fixé par le SDK Flutter : « à vérifier », non déterminé.
- CA9 : un type de build `release` signé par une configuration dédiée qui lit ses valeurs dans `key.properties` ou des variables porte « OK », et la présence de `key.properties` est indiquée sans le lire.
- CA11 : le détail de l'élément « configuration de signature » cite la ligne et nomme le cas (configuration `debug` ou aucune configuration).
- CA12 : `firebase_options.dart` (configuration FlutterFire) rejoint la liste des fichiers sensibles ; aucun des fichiers sensibles de CA12, fichiers de configuration compris, n'est ouvert : leur présence est repérée par leur nom seul.
- CA12 : la recherche dans le code se fait par nom de fichier (sans afficher de contenu), limitée aux fichiers de code et de build, puis seuls les fichiers non sensibles sont lus.
- CA12 : chaque checklist contient une ligne « Fichiers sensibles » quand il y en a pour sa plateforme : présence de chacun, « OK », non bloquant, ou « à faire », non bloquant, pour un fichier de clés suivi par git.
- CA13 : seuls les fichiers de clés (`key.properties`, `*.jks`, `*.keystore`, `*.p12`, `*.p8`) déclenchent l'alerte ; l'alerte invite à retirer le fichier du dépôt.
- CA14 : un mot de passe en clair porte « à faire », non bloquant si la signature est par ailleurs correcte (il n'empêche pas la soumission), bloquant si la signature relève aussi de CA11 ; les fichiers de build examinés sont `build.gradle`, `build.gradle.kts` et `gradle.properties`.
- CA15 : les éléments d'exigence évolutive (niveau de `targetSdk` et SDK iOS ou Xcode de build) sont bloquants ; la valeur iOS relevée vient d'un fichier `.xcode-version` ou de la CI, sinon « non déterminé » ; seules les deux pages officielles sont consultées, sans rien envoyer du projet, et la date s'écrit « consulté le AAAA-MM-JJ ».
- CA17 : les décomptes portent sur les lignes des checklists seulement, hors « Étapes hors projet » ; une plateforme absente s'écrit « non applicable » dans le décompte.
- CA18 : les métadonnées reprises sont celles de fastlane en français (`fr-FR`, `fr-CA` ou `fr`), dans le dossier de l'application ou dans ses dossiers `ios/` et `android/` ; un champ dont le fichier manque porte « non déterminé » avec le chemin cherché, sans brouillon mêlé, et figure dans « Points non déterminés » ; un brouillon n'invente aucune fonctionnalité absente de ses sources.
- CA22 : le décompte compte tous les caractères, espaces, ponctuation et retours à la ligne compris, sans le retour à la ligne final du fichier.
- CA23 : le compte de démonstration figure toujours, au statut « à vérifier » ; sans connexion repérée, l'outil l'écrit.
- CA25 : chaque sous-section par application s'intitule « <nom> (`<dossier>`) », dans le même ordre dans toutes les sections ; avec une seule application, pas de sous-section.
- CA26 : hors dépôt git ou dans un dépôt sans commit, l'en-tête indique « hors git », sans mention « modifications non commitées » ; une modification qui ne concerne que le livrable lui-même ne déclenche pas cette mention.
