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
- CA5 : Étant donné un projet dont une partie du code n'a aucun test, alors la section « Qualité et tests » le signale en citant le chemin concerné.
- CA6 : Étant donné un dépôt git, alors « Activité du dépôt » indique la date du premier et du dernier commit, le nombre de contributeurs et les fichiers les plus souvent modifiés sur les 12 derniers mois.
- CA7 : Étant donné un fichier à la fois parmi les plus modifiés et sans test, alors il apparaît dans « Dette et risques ».
- CA8 : Étant donné le livrable, alors chaque risque listé dans « Dette et risques » a un niveau (élevé, moyen, faible) et cite au moins un fichier du projet.
- CA9 : Étant donné le livrable, alors « Effort de reprise » donne une estimation qualitative (faible, moyen, élevé) justifiée par les risques listés, sans chiffrage en jours.
- CA10 : Étant donné un projet contenant un fichier `.env` avec un secret, alors le livrable ne contient pas ce secret, et l'outil ne lit pas ce fichier.
- CA11 : Étant donné le livrable, alors il ne contient aucune adresse e-mail de contributeur.
- CA12 : Étant donné un livrable `docs/wf/analyse-projet.md` déjà présent, quand je relance l'outil, alors le fichier est mis à jour (date et commit d'en-tête actualisés) au lieu d'être dupliqué.
- CA13 : Étant donné le livrable, alors son en-tête indique l'outil, la date et le commit analysé.

## Cas limites et erreurs

- Répertoire vide ou sans code : l'outil le dit et n'écrit pas de livrable.
- Projet qui n'est pas un dépôt git : l'en-tête indique « hors git » au lieu du commit, et « Activité du dépôt » indique « non applicable ».
- Historique git tronqué (clone superficiel) : signalé dans « Points non déterminés ».
- Monorepo (plusieurs applications) : chaque application est décrite dans « Architecture », la synthèse reste globale.
- Projet volumineux : l'outil échantillonne et l'indique dans « Points non déterminés » plutôt que de conclure sur ce qu'il n'a pas lu.
- Information impossible à établir (ex. hébergement) : mentionnée dans « Points non déterminés », jamais inventée.

## Hors périmètre

- Documentation à destination de l'équipe ou du client (c'est `wf-doc-projet`).
- Chiffrage en jours (c'est `wf-chiffrage`).
- Audit de sécurité approfondi (c'est `wf-revue-securite`) : ici, seulement les signaux visibles.
- Exécution du projet, de ses tests ou installation de ses dépendances.

## Questions ouvertes

- Aucune.
