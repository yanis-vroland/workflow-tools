# Spec 001 : wf-analyse-projet, diagnostic d'un projet existant

Statut : validée
Date : 2026-10-09

## Besoin

En tant que freelance qui reprend ou audite un projet existant, je veux obtenir en une commande un diagnostic de son état, afin d'évaluer les risques et l'effort de reprise avant de m'engager ou de chiffrer.

Le livrable s'adresse à moi (usage interne), pas au client. Il suit les conventions de l'ADR-001.

## Critères d'acceptation

- CA1 : Étant donné un projet cible, quand je lance `/wf-analyse-projet` à sa racine, alors le fichier `docs/wf/analyse-projet.md` est créé et aucun autre fichier du projet n'est modifié.
- CA2 : Étant donné le livrable produit, alors il contient dans cet ordre les sections : Synthèse, Stack et dépendances, Architecture, Activité du dépôt, Qualité et tests, Sécurité, Dette et risques, Effort de reprise, Points non déterminés.
- CA3 : Étant donné un projet dont une dépendance a au moins une version majeure de retard, alors la section « Stack et dépendances » la cite avec sa version installée et la dernière version publiée, obtenue en interrogeant le registre de paquets (npm, Packagist, PyPI, pub.dev…).
- CA4 : Étant donné un registre de paquets injoignable, alors l'outil se replie sur les versions du lockfile, le signale dans « Points non déterminés » et produit tout de même le livrable.
- CA5 : Étant donné un fichier source qu'aucun test ne couvre, alors la section « Qualité et tests » le cite. Un fichier source est réputé couvert si un fichier de test l'importe ou porte son nom (ex. `invoice.ts` et `invoice.test.ts`). Cette heuristique est approximative : la section « Qualité et tests » le précise à chaque exécution.
- CA6 : Étant donné un dépôt git, alors « Activité du dépôt » indique la date du premier et du dernier commit, le nombre de contributeurs, et les 10 fichiers les plus souvent modifiés sur les 12 derniers mois, avec leur nombre de commits.
- CA7 : Étant donné un fichier présent à la fois dans ce top 10 et parmi les fichiers non couverts (CA5), alors il apparaît dans « Dette et risques ».
- CA8 : Étant donné le livrable, alors chaque risque listé dans « Dette et risques » a un niveau (élevé, moyen, faible) et cite au moins un fichier du projet.
- CA9 : Étant donné le livrable, alors « Effort de reprise » donne une estimation qualitative (faible, moyen, élevé) justifiée par les risques listés, sans chiffrage en jours.
- CA10 : Étant donné un projet contenant un fichier `.env*` autre que `.env.example`, alors l'outil ne lit pas ce fichier et le livrable ne contient aucune de ses valeurs. Le fichier `.env.example` peut être lu.
- CA11 : Étant donné le livrable, alors il ne contient aucune adresse e-mail de contributeur.
- CA12 : Étant donné un livrable `docs/wf/analyse-projet.md` déjà présent, quand je relance l'outil, alors le fichier est mis à jour (date et commit d'en-tête actualisés) au lieu d'être dupliqué.
- CA13 : Étant donné le livrable, alors son en-tête indique l'outil, la date et le commit analysé, suivi de la mention « modifications non commitées » si le répertoire de travail n'est pas propre.
- CA14 : Étant donné un répertoire vide ou sans code source, quand je lance l'outil, alors il l'indique et n'écrit aucun livrable.
- CA15 : Étant donné un projet qui n'est pas un dépôt git, alors l'en-tête indique « hors git » au lieu du commit, et « Activité du dépôt » indique « non applicable ».
- CA16 : Étant donné un clone superficiel (historique tronqué), alors « Points non déterminés » le signale et « Activité du dépôt » précise la période réellement couverte.
- CA17 : Étant donné un monorepo (plusieurs applications), alors « Architecture » décrit chaque application dans une sous-section, et la synthèse reste globale.
- CA18 : Étant donné une partie du code que l'outil n'a pas lue (projet volumineux), alors « Points non déterminés » liste les dossiers non lus, et aucune conclusion ne porte sur eux.
- CA19 : Étant donné une information impossible à établir à partir des fichiers (ex. hébergement), alors elle figure dans « Points non déterminés » et n'est affirmée nulle part ailleurs.
- CA20 : Étant donné un projet situé dans un sous-dossier d'un dépôt git, quand je lance l'outil à la racine de ce sous-dossier, alors le projet est traité comme un dépôt git : l'en-tête indique le commit du dépôt et le sous-dossier analysé, et l'inventaire des fichiers comme « Activité du dépôt » ne portent que sur ce sous-dossier.

## Cas limites et erreurs

Couverts par CA4 et CA14 à CA20.

## Hors périmètre

- Documentation à destination de l'équipe ou du client (c'est `wf-doc-projet`).
- Chiffrage en jours (c'est `wf-chiffrage`).
- Audit de sécurité approfondi (c'est `wf-revue-securite`) : ici, seulement les signaux visibles.
- Exécution du projet, de ses tests ou installation de ses dépendances.

## Questions ouvertes

- Aucune.

## Amendement (proposé)

Date : 2026-10-20

La revue de l'heuristique de couverture a montré des noms de fichiers qu'elle traitait mal, et un fichier d'environnement qu'elle pouvait lire. Cet amendement précise CA5 et CA10 ; en cas de conflit, il prévaut.

- CA5 : le nom d'un fichier source ou de test est pris littéralement, quels que soient les caractères qu'il contient (parenthèses, crochets, points, tiret initial…). Un fichier importé par un test reste couvert même si son nom contient un caractère spécial ; un fichier de test dont le nom commence par un tiret est lu comme un fichier, jamais comme une option de commande ; un point du nom ne correspond qu'à un point.
- CA10 : un fichier `.env*` est exclu de l'inventaire des fichiers source même si son nom finit par une extension de code (ex. `.env.test.js`, qui ressemble à un fichier de test) : il n'est donc jamais lu, ni par la recherche des imports de la couverture, ni par aucune autre étape.
