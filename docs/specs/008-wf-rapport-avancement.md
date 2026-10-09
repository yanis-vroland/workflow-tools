# Spec 008 : wf-rapport-avancement, rapport d'avancement sur une période

Statut : brouillon
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
