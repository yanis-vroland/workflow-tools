# Spec 009 : wf-release-notes, notes de version

Statut : validée
Date : 2026-10-09

## Besoin

En tant que freelance qui livre une nouvelle version d'une application web ou mobile, je veux générer les notes de version à partir des changements réellement intégrés, afin d'informer le client et les utilisateurs de ce qui change sans relire l'historique à la main.

Les notes s'adressent au client et aux utilisateurs finaux, lecteurs non techniques ; le détail technique reste accessible par la sous-section « Références ».

L'entrée principale n'est pas le code du projet mais son historique git entre deux références (par défaut, du dernier tag de version à `HEAD`) : messages de commit et, si besoin, leurs diffs.

Le livrable suit les conventions de l'ADR-001 et de son amendement 1, en particulier l'organisation « fichier unique cumulatif » : une section par version, ajoutée en tête, sans réécrire les sections des versions précédentes.

### Contrat avec les autres outils

Les noms du fichier `docs/wf/release-notes.md`, des sections de version (`## Version <numéro> (<AAAA-MM-JJ>)`) et des sous-sections (Nouveautés, Améliorations, Corrections, Points d'attention, Références, Points non déterminés) sont un contrat au sens de l'amendement 1 de l'ADR-001 : `wf-publication-store` (spec 015) reprend la sous-section « Nouveautés » de la version la plus récente. Les changer impose de mettre à jour la spec 015.

## Critères d'acceptation

- CA1 : Étant donné un projet cible qui est un dépôt git, quand je lance `/wf-release-notes` à sa racine, alors le fichier `docs/wf/release-notes.md` est créé et aucun autre fichier du projet n'est modifié : ni `CHANGELOG.md`, ni le numéro de version du manifeste, et aucun tag n'est créé.
- CA2 : Étant donné le livrable produit, alors il contient un en-tête puis une section `## Version <numéro> (<AAAA-MM-JJ>)` par version, la plus récente en tête. Chaque section de version contient dans cet ordre les sous-sections : Nouveautés, Améliorations, Corrections, Points d'attention, Références, Points non déterminés. Une sous-section sans entrée est omise, sauf Références.
- CA3 : Étant donné le livrable produit, alors son en-tête contient les éléments prévus par l'ADR-001, le commit analysé étant la borne haute de la plage de la dernière version générée.
- CA4 : Étant donné aucune référence en argument, alors la plage couverte va du dernier tag de version accessible depuis `HEAD` (exclu) jusqu'à `HEAD` (inclus). Un tag de version est un tag de la forme `X.Y.Z` ou `vX.Y.Z`.
- CA5 : Étant donné deux références git passées en argument (ex. `/wf-release-notes v1.3.0 v1.4.0`), alors la plage couverte va de la première (exclue) à la seconde (incluse).
- CA6 : Étant donné un numéro de version passé en argument, alors il est utilisé ; sinon le numéro est lu dans le manifeste du projet (`version` de `package.json` ou de `pubspec.yaml`), en citant le fichier lu ; sinon le titre de la section indique « Version non déterminée » et « Points non déterminés » le signale.
- CA7 : Étant donné un numéro de version de manifeste mobile qui comporte un numéro de build (ex. `1.4.0+42` dans `pubspec.yaml`), alors le titre de la section n'affiche que `1.4.0`.
- CA8 : Étant donné des commits au format Conventional Commits, alors `feat` va dans « Nouveautés », `perf` dans « Améliorations », `fix` dans « Corrections », et tout commit marqué `!` ou contenant `BREAKING CHANGE:` va dans « Points d'attention ». Les commits `chore`, `ci`, `test`, `refactor`, `build`, `style` et `docs` ne produisent aucune entrée.
- CA9 : Étant donné un commit qui ne suit pas Conventional Commits, alors l'outil le classe d'après son message et son diff ; s'il ne peut pas le classer, le commit figure dans « Points non déterminés » avec son hash court.
- CA10 : Étant donné une plage dont aucun commit ne produit d'entrée (uniquement des travaux techniques), alors la section de version indique « Aucun changement visible pour les utilisateurs ».
- CA11 : Étant donné le livrable, alors les entrées de « Nouveautés », « Améliorations », « Corrections » et « Points d'attention » sont rédigées pour un utilisateur non développeur : elles ne contiennent ni chemin de fichier, ni nom de fonction, ni hash de commit.
- CA12 : Étant donné le livrable, alors la sous-section « Références » de chaque version rattache chaque entrée à ses commits (hash court) et, si le message en mentionne, à ses numéros de PR ou de ticket ; chaque commit de la plage y figure exactement une fois, rattaché à une entrée ou marqué « sans entrée » avec son type. Les commits de fusion n'y figurent pas en tant que tels.
- CA13 : Étant donné plusieurs commits qui portent sur la même fonctionnalité, alors ils produisent une seule entrée.
- CA14 : Étant donné un commit `fix` qui corrige une fonctionnalité introduite par un commit `feat` de la même plage (ex. `feat(export): export PDF des interventions` puis `fix(export): marge du PDF des interventions`), alors il ne produit pas d'entrée dans « Corrections » : il est rattaché à l'entrée de la fonctionnalité dans « Nouveautés ».
- CA15 : Étant donné un commit et le commit qui l'annule (`revert`) dans la même plage, alors aucun des deux ne produit d'entrée.
- CA16 : Étant donné un changement cassant, alors son entrée dans « Points d'attention » décrit l'action requise de l'utilisateur ou du client si le commit la décrit, et indique « action requise non déterminée » sinon.
- CA17 : Étant donné un livrable qui contient déjà une section pour le même numéro de version, quand je relance l'outil, alors cette section est mise à jour au lieu d'être dupliquée, et les sections des autres versions restent identiques octet pour octet.
- CA18 : Étant donné un livrable qui contient déjà des sections pour des versions antérieures, quand je lance l'outil pour une nouvelle version, alors sa section est ajoutée en tête et les sections existantes restent identiques octet pour octet, y compris si elles ont été retouchées à la main.
- CA19 : Étant donné un dépôt sans aucun tag de version et aucune référence en argument, alors la plage part du premier commit du dépôt et « Points non déterminés » le signale.
- CA20 : Étant donné une plage qui ne contient aucun commit, quand je lance l'outil, alors il l'indique et le livrable n'est ni créé ni modifié.
- CA21 : Étant donné une référence passée en argument qui n'existe pas dans le dépôt, quand je lance l'outil, alors il l'indique et le livrable n'est ni créé ni modifié.
- CA22 : Étant donné un projet qui n'est pas un dépôt git, quand je lance l'outil, alors il indique qu'il ne peut pas établir les changements et n'écrit aucun livrable.
- CA23 : Étant donné un clone superficiel dont l'historique ne contient pas la borne basse de la plage, alors « Points non déterminés » le signale et indique le premier commit réellement disponible.
- CA24 : Étant donné des modifications non commitées, alors elles ne sont pas prises en compte dans les notes de version.
- CA25 : Étant donné le livrable, alors il ne contient aucun nom de contributeur (en plus de l'absence d'adresse e-mail prévue par l'ADR-001).
- CA26 : Étant donné un fichier `.env*` autre que `.env.example` versionné dans le dépôt, alors l'outil n'en lit ni le contenu ni le diff, et le livrable ne contient aucune de ses valeurs.

## Cas limites et erreurs

Couverts par CA7, CA9, CA10, CA14, CA15 et CA19 à CA26.

## Hors périmètre

- Création du tag, incrément du numéro de version, publication de la release (GitHub, GitLab).
- Déduction du numéro de version à partir des types de commits (règles SemVer).
- Modification d'un `CHANGELOG.md` existant du projet, et notes de version au format technique pour développeurs.
- Mise en forme des textes « Nouveautés » des fiches App Store et Google Play et de leurs limites de longueur (c'est `wf-publication-store`, qui part de la sous-section « Nouveautés » de ce livrable).
- Avancement du travail sur une période, livré ou non (c'est `wf-rapport-avancement`).
- Vérification que la version fonctionne (c'est `wf-recette`).

## Questions ouvertes

- Aucune.

## Amendement 1 (validé)

Précisions issues de l'implémentation, validées. Chacune complète le CA indiqué.

- CA1 : l'outil ne lit aucun fichier du projet autre que le livrable ; tout ce qu'il établit (commits, diffs, manifeste) vient de l'historique git.
- CA2 : le livrable commence par le titre `# Notes de version`, suivi de l'en-tête.
- CA2 : sous chaque titre de version, une ligne « Plage » nomme les bornes telles qu'elles ont été passées ou trouvées (nom de tag, de branche ou `HEAD`, jamais un hash), indique le nombre de commits hors commits de fusion et la source du numéro de version.
- CA2 : la date du titre de version est la date du commit de la borne haute.
- CA5 : une seule référence passée en argument est la borne basse ; la borne haute est alors `HEAD`. Plus de deux références : l'outil rappelle la syntaxe et n'écrit rien.
- CA6 : le numéro de version est passé par l'option `--version <numéro>`. Il est accepté s'il ne contient que lettres, chiffres, `.`, `+` et `-` sans commencer par `-` ; sinon l'outil indique « numéro de version refusé » et n'écrit rien.
- CA6 : le manifeste lu est celui de la racine du projet, `package.json` puis `pubspec.yaml`, dans son état au commit de la borne haute (une modification non commitée n'est pas prise en compte). Un numéro n'est jamais déduit d'un tag ni des types de commits.
- CA8 : un commit cassant ne produit qu'une entrée, dans « Points d'attention », même s'il est de type `feat` ou `fix`.
- CA9 : un commit hors convention dont le message et le diff montrent un travail sans effet pour les utilisateurs est marqué « sans entrée » avec le type retenu et la mention « hors convention ».
- CA12 : dans « Références », une ligne par entrée cite tous ses commits, une ligne par commit sans entrée porte « sans entrée (<type>) », et aucune ligne ne cite un autre hash que ceux de son entrée ou de son commit.
- CA12 : un identifiant de ticket est un identifiant de la forme `PROJET-123` ou un identifiant entre parenthèses en fin de sujet ; un numéro de PR est de la forme `#123` ou `!123`.
- CA14 : un `fix` est rattaché à une nouveauté de la même plage quand il porte la même portée et le même objet que le `feat`, ou quand son diff touche les fichiers de ce `feat`.
- CA15 : un revert dont le commit annulé est hors de la plage ne produit aucune entrée ; il figure dans « Points non déterminés » avec son hash court.
- CA17 : une section « Version non déterminée » n'est jamais remplacée par une relance : une relance sans numéro de version ajoute une nouvelle section.
- CA18 : la nouvelle section est ajoutée en tête, sauf si une section existante porte un numéro supérieur : elle est alors insérée avant la première section de numéro inférieur, pour que la plus récente reste en tête.
- CA17, CA18 : à la relance, l'outil ne réécrit jamais le livrable en entier ; il ne modifie que la ligne d'en-tête et la section de la version produite.
- CA21 : une référence vide, commençant par `-`, sur plusieurs lignes, ou contenant un caractère hors de lettres, chiffres, `.`, `_`, `/`, `~`, `^`, `@`, `{`, `}`, `+` et `-` est refusée avant toute commande, avec le message « référence refusée : caractères non pris en charge » ; aucun livrable n'est écrit ni modifié.
- CA21 : une valeur qui commence par `-` n'est jamais transmise à une commande git, afin qu'aucune référence ne soit interprétée comme une option de git.
- CA22 : un dépôt parent sans commit, ou qui ne suit pas le dossier du projet, compte comme « pas un dépôt git ».
- CA26 : en plus des fichiers `.env*`, l'outil ne lit le contenu ni le diff d'aucun fichier d'identifiants (`.envrc`, `.npmrc`, `key.properties`, clés et certificats), même versionné.
