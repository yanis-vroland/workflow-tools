# Spec 006 : wf-specs-tickets, découpage d'un besoin cadré en tickets

Statut : brouillon
Date : 2026-10-09

## Besoin

En tant que chef de projet et développeur freelance qui démarre la réalisation, je veux transformer le besoin cadré en tickets prêts à développer, chacun avec ses critères d'acceptation, afin d'alimenter l'outil de suivi du projet sans tout réécrire à la main.

Le livrable s'adresse à l'équipe de développement (moi, d'autres développeurs, éventuellement le client qui suit le backlog). Il suit les conventions de l'ADR-001 et de son amendement 1 (fichier unique mis à jour, écriture limitée à `docs/wf/`, entrées hors du code, dépendances entre outils).

### Entrée de l'outil

- Entrée par défaut : le livrable de cadrage `docs/wf/cadrage-besoin.md` (spec 004), dont l'outil lit les sections « Besoins fonctionnels » et « Questions au client », et reprend les identifiants `Bnn` et `Qnn`.
- Entrée alternative : un fichier de besoin passé en argument (`/wf-specs-tickets <chemin>`). Le texte saisi dans la commande n'est pas accepté.
- Entrées complémentaires, si elles existent : les sections « Détail par lot » et « Activités transverses » de `docs/wf/chiffrage.md` (spec 005), dont l'outil reprend les tâches `Cnn` sans réestimer, et le code du projet cible, pour citer les fichiers concernés.

Chaque ticket est rédigé en Markdown générique, pour être collé tel quel comme description d'issue (GitHub, GitLab…). L'outil ne crée aucun ticket dans un outil de suivi.

### Contrat avec les autres outils

Le livrable est lu par `wf-rapport-avancement` (spec 008) et `wf-recette` (spec 014). Conformément à l'amendement 1 de l'ADR-001, sont un contrat, à ne changer qu'en mettant à jour ces specs :

- le chemin `docs/wf/specs-tickets.md` (toujours un fichier unique, jamais un dossier) ;
- les noms des sections listées en CA2 et des rubriques de ticket listées en CA4 ;
- les identifiants de tickets `Tnn` et les numéros de critères d'acceptation `CAn` propres à chaque ticket, cités ailleurs sous la forme `Tnn-CAn` (ex. `T03-CA2`).

## Critères d'acceptation

- CA1 : Étant donné un projet cible contenant `docs/wf/cadrage-besoin.md`, quand je lance `/wf-specs-tickets` à sa racine, alors le fichier `docs/wf/specs-tickets.md` est créé et aucun autre fichier n'est modifié.
- CA2 : Étant donné le livrable produit, alors il contient dans cet ordre les sections : Synthèse, Ordre de réalisation, Tickets, Besoins non couverts, Points non déterminés.
- CA3 : Étant donné le livrable, alors son en-tête est conforme à l'ADR-001 et liste en plus les fichiers d'entrée utilisés (nom de fichier seul).
- CA4 : Étant donné la section « Tickets », alors chaque ticket est une sous-section titrée `Tnn : <titre>` (`T01`, `T02`…) contenant dans cet ordre les rubriques : Récit utilisateur (« En tant que…, je veux…, afin de… »), Contexte, Critères d'acceptation, Hors périmètre, Dépendances, Besoins couverts, Estimation, Fichiers concernés, Points à clarifier.
- CA5 : Étant donné un ticket, alors sa rubrique « Critères d'acceptation » contient au moins un critère ; les critères sont numérotés `CA1`, `CA2`… à partir de 1 dans chaque ticket, et chacun est au format « Étant donné…, quand…, alors… ».
- CA6 : Étant donné un critère d'acceptation d'un ticket, alors il ne contient aucun des termes « rapide », « simple », « intuitif », « facile », « convivial », « performant » sans valeur mesurable associée (durée, nombre, seuil).
- CA7 : Étant donné un cadrage contenant N besoins, alors chacun des N identifiants `Bnn` apparaît dans la rubrique « Besoins couverts » d'au moins un ticket, ou dans « Besoins non couverts » avec la raison.
- CA8 : Étant donné un ticket, alors sa rubrique « Besoins couverts » cite au moins un identifiant `Bnn` existant dans le cadrage.
- CA9 : Étant donné un projet cible contenant `docs/wf/chiffrage.md`, alors la rubrique « Estimation » de chaque ticket cite les tâches `Cnn` qu'il couvre, sans nouvelle estimation ; sans livrable de chiffrage, elle indique « non estimé ».
- CA10 : Étant donné un projet cible contenant `docs/wf/chiffrage.md`, alors pour chaque ticket qui cite au moins deux tâches `Cnn`, la somme de leurs estimations hautes est d'au plus 5 jours ; au-delà, le ticket est découpé.
- CA11 : Étant donné une question `Qnn` du cadrage dont le champ « Réponse : » est vide et qui porte sur un besoin couvert par un ticket, alors la rubrique « Points à clarifier » de ce ticket cite cette question ; sinon, elle indique « aucun ».
- CA12 : Étant donné le livrable, alors « Ordre de réalisation » liste tous les tickets une seule fois, chaque ticket après ceux dont il dépend, et contient un schéma Mermaid des dépendances entre tickets.
- CA13 : Étant donné des dépendances qui forment un cycle, alors le cycle est décrit dans « Points non déterminés » en citant les tickets concernés, et « Ordre de réalisation » l'indique au lieu de proposer un ordre.
- CA14 : Étant donné un projet cible contenant du code source, alors chaque chemin cité dans « Fichiers concernés » existe dans le projet, ou est explicitement marqué « à créer ».
- CA15 : Étant donné la fixture `tests/fixtures/fieldops-brief/` (projet sans code source) après exécution de `/wf-cadrage-besoin`, quand je lance l'outil, alors le livrable est créé normalement et la rubrique « Fichiers concernés » de chaque ticket indique « non applicable (projet sans code) ».
- CA16 : Étant donné un livrable déjà présent, quand je relance l'outil, alors il est mis à jour au lieu d'être dupliqué ; un ticket dont les besoins couverts n'ont pas changé conserve son identifiant `Tnn` et ses critères conservent leur numéro `CAn` ; l'identifiant d'un ticket supprimé, ou le numéro d'un critère supprimé dans un ticket, n'est jamais réattribué.
- CA17 : Étant donné une exécution de l'outil, alors aucun ticket n'est créé ni modifié dans un outil de suivi et aucune connexion n'est faite à un service privé (amendement 1).
- CA18 : Étant donné un projet cible sans `docs/wf/cadrage-besoin.md` et sans argument, quand je lance l'outil, alors il indique qu'il faut d'abord lancer `/wf-cadrage-besoin` ou fournir un fichier de besoin, et n'écrit aucun livrable.
- CA19 : Étant donné un fichier d'entrée qui ne contient aucun besoin identifiable, ou un texte saisi dans la commande au lieu d'un chemin, quand je lance l'outil, alors il l'indique et n'écrit aucun livrable.
- CA20 : Étant donné le livrable, alors « Synthèse » recommande de citer l'identifiant `Tnn` du ticket dans le nom de la branche ou dans le message du commit qui le réalise (ex. `feat/T03-export-pdf`), pour permettre le suivi par `wf-rapport-avancement` ; la convention est présentée comme une recommandation, non comme une obligation.
- CA21 : Étant donné un projet contenant un fichier `.env*` autre que `.env.example`, alors l'outil ne lit pas ce fichier et le livrable ne contient aucune de ses valeurs.
- CA22 : Étant donné un fichier d'entrée contenant des adresses e-mail ou des numéros de téléphone, alors le livrable n'en contient aucun.

## Cas limites et erreurs

Couverts par CA13, CA15, CA16, CA18, CA19, CA21 et CA22.

## Hors périmètre

- Cadrage du besoin et questions au client (c'est `wf-cadrage-besoin`).
- Estimation de la charge (c'est `wf-chiffrage`) : l'outil reprend les tâches chiffrées, il ne réestime pas.
- Création, mise à jour ou synchronisation de tickets dans un outil de suivi (GitHub Issues, GitLab, Jira, Linear…), et export CSV ou JSON.
- Ticket isolé rédigé à partir d'une demande saisie dans la commande.
- Spécification technique détaillée (schéma de base de données, contrats d'API, maquettes).
- Plan et statuts de recette (c'est `wf-recette`).
- Suivi de l'avancement des tickets (c'est `wf-rapport-avancement`).

## Questions ouvertes

Seuil à ajuster après les premiers essais sur de vrais projets :

- Taille maximale d'un ticket : 5 jours d'estimation haute cumulée (CA10), aligné sur la taille maximale d'une tâche de la spec 005.
