# Spec 005 : wf-chiffrage, estimation de la charge d'un besoin cadré

Statut : validée
Date : 2026-10-09

## Besoin

En tant que freelance qui doit répondre à une demande client, je veux obtenir une estimation détaillée et traçable de la charge, afin de construire mon devis sur une base argumentée et de savoir sur quelles hypothèses il repose.

Le livrable s'adresse à moi seul (usage interne, base de mon devis), pas au client. Il suit les conventions de l'ADR-001 et de son amendement 1 (entrées hors du code, dépendances entre outils).

### Entrée de l'outil

- Entrée par défaut : le livrable de cadrage `docs/wf/cadrage-besoin.md` (spec 004), dont l'outil lit les sections « Besoins fonctionnels », « Contraintes », « Hypothèses » et « Questions au client », et reprend les identifiants `Bnn` et `Qnn`.
- Entrée alternative : un fichier de besoin passé en argument (`/wf-chiffrage <chemin>`). Le texte saisi dans la commande n'est pas accepté.
- Entrées complémentaires, si elles existent : le code du projet cible (évolution d'une application existante) et la section « Dette et risques » de `docs/wf/analyse-projet.md` (spec 001).

### Règles de chiffrage

- Estimation en jours, par pas de 0,5 jour, sous forme de fourchette basse et haute.
- Aucun montant ni taux journalier.
- Les activités transverses (gestion de projet, recette, déploiement, publication sur les stores) sont des lignes estimées comme les autres, proposées seulement quand le cadrage les justifie.

### Contrat avec les autres outils

Le livrable est lu par `wf-specs-tickets` (spec 006). Conformément à l'amendement 1 de l'ADR-001, sont un contrat : le chemin `docs/wf/chiffrage.md`, les noms des sections listées en CA2, et les identifiants de tâches `Cnn`.

## Critères d'acceptation

- CA1 : Étant donné un projet cible contenant `docs/wf/cadrage-besoin.md`, quand je lance `/wf-chiffrage` à sa racine, alors le fichier `docs/wf/chiffrage.md` est créé et aucun autre fichier n'est modifié, y compris le livrable de cadrage.
- CA2 : Étant donné le livrable produit, alors il contient dans cet ordre les sections : Synthèse, Périmètre chiffré, Détail par lot, Activités transverses, Hypothèses, Exclusions, Risques, Points non déterminés.
- CA3 : Étant donné le livrable, alors son en-tête est conforme à l'ADR-001 et indique en plus le fichier d'entrée utilisé (nom de fichier seul) et la date figurant dans l'en-tête de ce fichier.
- CA4 : Étant donné le livrable, alors chaque tâche de « Détail par lot » et de « Activités transverses » figure dans un tableau avec les colonnes : identifiant (`C01`, `C02`…), tâche, besoins couverts (`Bnn`), estimation basse, estimation haute, commentaire.
- CA5 : Étant donné le livrable, alors toutes les estimations sont exprimées en jours, par pas de 0,5 jour, et pour chaque tâche l'estimation haute est supérieure ou égale à l'estimation basse.
- CA6 : Étant donné le livrable, alors aucune tâche n'a une estimation haute supérieure à 5 jours ; une tâche plus grosse est découpée en plusieurs tâches.
- CA7 : Étant donné une tâche dont l'estimation haute est au moins le double de l'estimation basse, alors sa colonne commentaire explique l'incertitude et cite l'hypothèse ou le risque qui la cause.
- CA8 : Étant donné le livrable, alors le total bas et le total haut figurent dans « Synthèse » et en fin de « Activités transverses », et chacun est exactement la somme des estimations correspondantes de toutes les tâches.
- CA9 : Étant donné un cadrage contenant N besoins, alors chacun des N identifiants `Bnn` apparaît soit dans au moins une tâche, soit dans « Exclusions » avec la raison de l'exclusion.
- CA10 : Étant donné une tâche de « Détail par lot », alors elle couvre au moins un besoin `Bnn` du cadrage ; seules les tâches de « Activités transverses » peuvent n'en couvrir aucun.
- CA11 : Étant donné une tâche de « Activités transverses », alors son commentaire cite l'élément du cadrage qui la justifie (ex. une tâche de publication sur les stores cite le besoin ou la contrainte qui demande une application mobile).
- CA12 : Étant donné un besoin trop imprécis pour être estimé, alors il figure dans « Exclusions » avec la mention « non chiffrable en l'état » et l'information manquante, et il n'est compté dans aucun total.
- CA13 : Étant donné une question `Qnn` du cadrage dont le champ « Réponse : » est vide et qui influe sur une estimation, alors elle donne lieu à une hypothèse dans « Hypothèses » qui cite son identifiant et les tâches `Cnn` concernées ; une question dont la réponse est remplie est prise en compte comme un fait, en citant `Qnn`.
- CA14 : Étant donné le livrable, alors il ne contient aucun montant (aucun symbole ou code monétaire, aucun taux journalier).
- CA15 : Étant donné un projet cible contenant du code source, alors « Hypothèses » indique que le code existant a été pris en compte et liste les dossiers lus ; chaque tâche portant sur du code existant cite dans son commentaire au moins un fichier existant du projet, et les dossiers non lus sont listés dans « Points non déterminés ».
- CA16 : Étant donné un projet cible contenant `docs/wf/analyse-projet.md`, alors « Risques » reprend chaque risque de niveau élevé de sa section « Dette et risques », en citant ce livrable, et indique les tâches `Cnn` qu'il affecte ou « aucune tâche affectée ».
- CA17 : Étant donné le livrable, alors chaque risque de « Risques » indique les tâches `Cnn` qu'il affecte, et si son effet est déjà inclus dans l'estimation haute ou non.
- CA18 : Étant donné un livrable `docs/wf/chiffrage.md` déjà présent, quand je relance l'outil, alors il est mis à jour au lieu d'être dupliqué, une tâche dont les besoins couverts n'ont pas changé dans le cadrage conserve son identifiant et ses estimations, et l'identifiant d'une tâche supprimée n'est jamais réattribué.
- CA19 : Étant donné un projet cible sans `docs/wf/cadrage-besoin.md` et sans argument, quand je lance l'outil, alors il indique qu'il faut d'abord lancer `/wf-cadrage-besoin` ou fournir un fichier de besoin, et n'écrit aucun livrable.
- CA20 : Étant donné un fichier d'entrée qui ne contient aucun besoin identifiable, ou un texte saisi dans la commande au lieu d'un chemin, quand je lance l'outil, alors il l'indique et n'écrit aucun livrable.
- CA21 : Étant donné un fichier passé en argument qui n'utilise pas les identifiants `Bnn` (ex. un cahier des charges brut), alors l'outil attribue lui-même des identifiants `Bnn` aux besoins, les liste dans « Périmètre chiffré » avec leur source (nom de fichier seul, et section ou page), et recommande dans « Points non déterminés » de passer par `/wf-cadrage-besoin`.
- CA22 : Étant donné la fixture `tests/fixtures/fieldops-brief/` (projet sans code source) après exécution de `/wf-cadrage-besoin`, quand je lance l'outil, alors le livrable est créé normalement et « Hypothèses » indique qu'il s'agit d'un développement à partir de zéro.
- CA23 : Étant donné un projet contenant un fichier `.env*` autre que `.env.example`, alors l'outil ne lit pas ce fichier et le livrable ne contient aucune de ses valeurs.
- CA24 : Étant donné un fichier d'entrée contenant des adresses e-mail ou des numéros de téléphone, alors le livrable n'en contient aucun.

## Cas limites et erreurs

Couverts par CA12 et CA18 à CA24.

## Hors périmètre

- Cadrage du besoin et questions au client (c'est `wf-cadrage-besoin`) : l'outil reprend les questions ouvertes sous forme d'hypothèses, il n'en crée pas de nouvelles.
- Découpage en tickets avec critères d'acceptation (c'est `wf-specs-tickets`) : les tâches de chiffrage sont un découpage d'estimation, pas des tickets de développement.
- Diagnostic du code existant (c'est `wf-analyse-projet`) : l'outil en reprend les risques, il ne le refait pas.
- Montants, devis, proposition commerciale, version du chiffrage destinée au client, planning.
- Suivi du consommé par rapport à l'estimé : couvert par aucun outil en v1 (`wf-rapport-avancement` exclut le temps passé et le budget).

## Questions ouvertes

Seuils à ajuster après les premiers essais sur de vrais projets :

- Taille maximale d'une tâche : 5 jours en estimation haute (CA6).
- Écart à justifier : estimation haute au moins double de l'estimation basse (CA7).
