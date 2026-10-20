# Spec 008 : wf-rapport-avancement, rapport d'avancement sur une période

Statut : validée
Date : 2026-10-09

## Besoin

En tant que freelance qui pilote un projet pour un client, je veux produire un rapport d'avancement sur une période à partir de ce qui a réellement été fait, afin d'informer le client sans reconstituer l'historique à la main.

Le rapport s'adresse au client, lecteur non technique ; le détail technique reste accessible par la section « Sources ». Il ne nomme pas les contributeurs et ne contient ni temps passé ni budget.

### Entrées de l'outil

- Entrée principale : l'historique git du projet sur la période (commits de la branche principale, branches non fusionnées), limité aux références connues localement : l'outil ne lance pas `git fetch`.
- Entrées complémentaires, si elles existent, lues sans jamais être modifiées (amendement 1 de l'ADR-001, dépendances entre outils) :
  - le livrable de `wf-specs-tickets` (spec 006), fichier unique `docs/wf/specs-tickets.md`, dont l'outil reprend les tickets de la section « Tickets » (sous-sections `Tnn : <titre>`) ;
  - les comptes rendus de `wf-compte-rendu` (spec 007) dans `docs/wf/compte-rendu/`, dont l'outil reprend la section « Questions en suspens ».
- Mes réponses aux questions de l'outil (période, prochaines étapes, décisions attendues) quand les fichiers ne suffisent pas.

L'outil ne se connecte à aucun outil de suivi de tickets en ligne (amendement 1 de l'ADR-001).

Le livrable suit les conventions de l'ADR-001 : fichier unique mis à jour, les rapports précédents restant dans l'historique git.

## Critères d'acceptation

- CA1 : Étant donné un projet cible qui est un dépôt git, quand je lance `/wf-rapport-avancement` à sa racine, alors le fichier `docs/wf/rapport-avancement.md` est créé et aucun autre fichier du projet n'est modifié.
- CA2 : Étant donné le livrable produit, alors il contient dans cet ordre les sections : Synthèse, Réalisé, En cours, Prochaines étapes, Points de vigilance, Décisions attendues, Points non déterminés, Sources.
- CA3 : Étant donné le livrable produit, alors son en-tête contient les éléments prévus par l'ADR-001, ainsi que la période couverte (date de début et date de fin, incluses) et les livrables `wf-` lus.
- CA4 : Étant donné une période passée en argument (ex. `/wf-rapport-avancement 2026-09-28 2026-10-09`), alors « Réalisé » ne porte que sur les commits de la branche principale dont la date de commit est comprise dans cette période, bornes incluses.
- CA5 : Étant donné aucune période en argument et un rapport précédent présent, alors la période va du lendemain de la date de fin indiquée dans l'en-tête du rapport précédent jusqu'à la date du jour. Sans rapport précédent, l'outil me demande la période.
- CA6 : Étant donné la branche principale, alors l'outil la détermine par `origin/HEAD`, à défaut `main`, à défaut `master` ; si aucune n'existe, il me la demande.
- CA7 : Étant donné le livrable, alors les entrées de « Réalisé » et « En cours » sont regroupées par fonctionnalité et rédigées pour un lecteur non développeur : elles ne contiennent ni chemin de fichier, ni nom de fonction, ni hash de commit.
- CA8 : Étant donné des commits de la période de types `chore`, `ci`, `test`, `refactor`, `build`, `style` ou `docs` (Conventional Commits), alors ils sont regroupés dans « Réalisé » en une seule entrée « Travaux techniques internes » qui indique leur nombre.
- CA9 : Étant donné le livrable, alors la section « Sources » rattache chaque entrée de « Réalisé » et « En cours » à ses commits (hash court) et, si le message en mentionne, à ses numéros de PR ou de ticket ; chaque commit de la période y figure exactement une fois. Les commits de fusion n'y figurent pas en tant que tels.
- CA10 : Étant donné une branche non fusionnée dans la branche principale et ayant au moins un commit dans la période, alors elle apparaît dans « En cours », une entrée par branche, décrite d'après ses commits.
- CA11 : Étant donné un livrable `docs/wf/specs-tickets.md` présent, alors « Prochaines étapes » liste, par leur identifiant `Tnn` et leur titre, les tickets dont l'identifiant n'apparaît dans aucun message de commit ni nom de branche fusionnée dans la branche principale. La section précise à chaque exécution que ce rapprochement repose sur la mention de l'identifiant (convention recommandée par `wf-specs-tickets`, non obligatoire) et reste approximatif.
- CA12 : Étant donné aucun livrable de `wf-specs-tickets`, alors l'outil me demande les prochaines étapes ; sans réponse, « Prochaines étapes » indique « non déterminé ». Dans tous les cas, aucune étape n'est déduite du code ni des commentaires `TODO`.
- CA13 : Étant donné des comptes rendus dans `docs/wf/compte-rendu/` dont la date de réunion (nom de fichier `AAAA-MM-JJ-…`) est dans la période, alors « Décisions attendues » reprend les entrées de leur section « Questions en suspens », en citant le nom du compte rendu source. Sans compte rendu dans la période, la section reprend ce que je fournis à l'outil, sinon indique « aucune identifiée ».
- CA14 : Étant donné le livrable, alors chaque point de « Points de vigilance » cite sa source (commit, compte rendu ou réponse de l'utilisateur). Un commit de type `revert` dans la période y figure systématiquement.
- CA15 : Étant donné le livrable, alors la « Synthèse » compte au plus 5 phrases.
- CA16 : Étant donné le livrable, alors il ne contient aucun nom de contributeur ni nombre de commits par personne (en plus de l'absence d'adresse e-mail prévue par l'ADR-001).
- CA17 : Étant donné le livrable, alors il ne contient aucun temps passé, budget consommé ni pourcentage d'avancement.
- CA18 : Étant donné un fichier `.env*` autre que `.env.example` versionné dans le dépôt, alors l'outil n'en lit ni le contenu ni le diff dans l'historique, et le livrable ne contient aucune de ses valeurs.
- CA19 : Étant donné une période sans aucun commit sur la branche principale, alors le livrable est tout de même produit, « Réalisé » indique « Aucune modification intégrée sur la période » et la « Synthèse » le dit.
- CA20 : Étant donné un rapport déjà présent, quand je relance l'outil, alors le fichier est mis à jour (en-tête, période et contenu) au lieu d'être dupliqué.
- CA21 : Étant donné une période invalide (date mal formée, date de fin antérieure à la date de début, date de début postérieure à la date du jour), quand je lance l'outil, alors il l'indique et n'écrit aucun livrable.
- CA22 : Étant donné un projet qui n'est pas un dépôt git, quand je lance l'outil, alors il indique qu'il ne peut pas établir l'avancement et n'écrit aucun livrable.
- CA23 : Étant donné un clone superficiel dont l'historique ne couvre pas toute la période, alors « Points non déterminés » le signale et indique la période réellement couverte.
- CA24 : Étant donné un commit dont le message ne permet pas de comprendre ce qui a été fait, alors l'outil s'appuie sur son diff ; s'il ne peut toujours pas le décrire, le commit figure dans « Points non déterminés » avec son hash court.

## Cas limites et erreurs

Couverts par CA5, CA6, CA12, CA13, et CA18 à CA24.

## Hors périmètre

- Compte rendu d'une réunion (c'est `wf-compte-rendu`) : ici, une période et plusieurs sources.
- Notes de version destinées aux utilisateurs (c'est `wf-release-notes`) : ici, l'avancement du travail, livré ou non.
- Diagnostic de la qualité ou de la dette (c'est `wf-analyse-projet`).
- Suivi du temps passé, du budget et de la facturation.
- Lecture d'un outil de suivi de tickets en ligne (amendement 1 de l'ADR-001).
- Modification des livrables `wf-` lus.
- Envoi du rapport au client et export PDF ou Word.

## Questions ouvertes

- Le plafond de 5 phrases pour la « Synthèse » (CA15) est une proposition, à ajuster après les premiers essais.

## Amendement 1 (proposé)

Précisions issues de l'implémentation, à valider. Chacune complète le CA indiqué.

- CA3 : l'en-tête indique la période sous la forme « du <début> au <fin> (bornes incluses) » et liste les livrables `wf-` lus par leur chemin (le livrable de tickets s'il existe, chaque compte rendu de la période effectivement lu), ou « aucun ».
- CA4 : la date de commit retenue est celle enregistrée dans le commit, dans le fuseau de son auteur ; un commit appartient à la période selon cette date, quel que soit le fuseau de la machine qui lance l'outil.
- CA5 : la date de fin du rapport précédent est lue sur sa ligne « Période » ; si elle est illisible, l'outil demande la période comme sans rapport précédent.
- CA6 : quand `origin/HEAD` désigne une branche, l'outil utilise la branche locale de ce nom, même si elle est en retard sur la branche distante, et à défaut la branche distante elle-même.
- CA6 : sans branche principale identifiable, l'outil n'écrit rien et demande la branche en citant les branches trouvées ; il n'en choisit jamais une lui-même.
- CA7 : les commits sans type Conventional Commits, ou dont le type n'est pas listé en CA8, sont décrits d'après leur message, ou leur diff si le message ne suffit pas. Un ajout suivi de son annulation dans la période forme une seule entrée de « Réalisé » qui dit les deux.
- CA8 : l'entrée « Travaux techniques internes » n'apparaît pas si la période ne contient aucun commit de ces types.
- CA9 : un commit présent dans plusieurs branches non fusionnées n'est rattaché qu'à une seule entrée de « En cours ». Les entrées de « En cours » sont rattachées dans « Sources » au nom de leur branche, qui n'apparaît pas dans « En cours ».
- CA10 : une branche locale et la branche distante de même nom sont une seule branche, donc une seule entrée ; sans branche en cours, la section le dit.
- CA11 : l'identifiant d'un ticket est cherché dans les messages de commit de toutes les branches connues localement (fusionnées ou non) et dans les noms des branches fusionnées dans la branche principale : un ticket mentionné sur une branche en cours n'est pas une prochaine étape. Si tous les tickets sont rapprochés, la section le dit, avant la mention du rapprochement approximatif.
- CA12 et CA13 : sans livrable de tickets ou sans compte rendu dans la période, le rapport est d'abord écrit avec « non déterminé » ou « aucune identifiée », puis l'outil pose ses questions (prochaines étapes, décisions attendues), regroupées dans son message final ; si l'utilisateur répond, le rapport est mis à jour avec la source « réponse de l'utilisateur ». Seules l'absence de période et l'absence de branche principale bloquent l'écriture.
- CA13 : une section « Questions en suspens » sans entrée, ou dont la seule entrée dit qu'il n'y en a aucune, est vide ; si toutes les sections lues sont vides, « Décisions attendues » indique « aucune identifiée ».
- CA14 : un point de vigilance tiré d'un commit d'annulation dit ce qui a été annulé ; la section ne contient aucun jugement de qualité ni de dette, et indique « Aucun point identifié. » s'il n'y a rien.
- CA21 : sont aussi des périodes invalides un nombre d'arguments autre que zéro ou deux, une date qui n'existe pas au calendrier, et une période calculée depuis le rapport précédent qui commencerait après la date du jour (rapport précédent couvrant déjà la date du jour). L'outil ne corrige ni n'inverse jamais les dates lui-même, et ne lit pas l'historique.
- CA22 : un dépôt sans aucun commit (y compris un dépôt parent vide) est traité comme un projet qui n'est pas un dépôt git.
- CA24 : un commit dont le diff ne contient que des fichiers binaires ou un contenu opaque est indescriptible. Les commits indescriptibles forment dans « Réalisé » une entrée « Modifications non décrites » qui indique leur nombre, rattachée à leurs commits dans « Sources », en plus de leur mention dans « Points non déterminés ».
- Cas limite (sécurité) : les valeurs venues du projet ou de l'utilisateur (dates, noms de branches, identifiants de commits et de tickets) sont vérifiées contre un format strict avant tout appel git et ne sont jamais interprétées par le shell. Une valeur qui commence par un tiret n'est jamais transmise à git, qui la lirait comme une option. Une branche dont le nom est refusé n'est pas lue et figure dans « Points non déterminés » comme branche non lue, sans description de son contenu.
- Cas limite : l'outil n'utilise aucune recherche de contenu dans les fichiers du projet ; il lit l'historique par git, les livrables `wf-` par lecture directe, et n'affiche jamais le diff d'un fichier d'environnement.
