# Spec 014 : wf-recette, cahier de recette d'un projet

Statut : validée
Date : 2026-10-09

## Besoin

En tant que freelance qui livre un projet ou une version à un client, je veux générer un cahier de recette à partir de ce qui a été spécifié, afin que le client et moi vérifiions la livraison selon une liste de cas partagée et tracions le résultat de chaque cas.

Le livrable s'adresse aux personnes qui conduisent la recette (client, chef de projet, testeur) : il décrit des vérifications manuelles, pas des tests automatisés. L'outil prépare les cas ; les résultats (statuts, commentaires) sont saisis à la main dans le livrable et conservés à la relance, conformément à l'amendement 1 de l'ADR-001.

### Entrées de l'outil

- Les specs du projet : fichiers `docs/specs/*.md` contenant des critères d'acceptation numérotés (`CA1`, `CA2`…).
- Le livrable de `wf-specs-tickets` (spec 006), s'il existe : fichier `docs/wf/specs-tickets.md`. Chaque ticket y est une sous-section `Tnn : <titre>` dont la rubrique « Critères d'acceptation » contient des critères numérotés `CA1`, `CA2`… dans chaque ticket, cités sous la forme `Tnn-CAn`. L'outil le lit sans le modifier.
- À défaut de ces deux sources, le code du projet.

Une seconde campagne (nouvelle version) met à jour le même fichier ; les résultats des campagnes précédentes restent dans l'historique git. Il suit les conventions de l'ADR-001 et de son amendement 1.

## Critères d'acceptation

- CA1 : Étant donné un projet cible, quand je lance `/wf-recette` à sa racine, alors le fichier `docs/wf/recette.md` est créé et aucun autre fichier du projet n'est modifié.
- CA2 : Étant donné le livrable produit, alors il contient dans cet ordre les sections : Périmètre et sources, Prérequis, Cas de recette, Couverture, Synthèse de la campagne, Points non déterminés.
- CA3 : Étant donné le livrable, alors « Cas de recette » est un tableau Markdown aux colonnes, dans cet ordre : ID, Fonctionnalité, Préconditions, Étapes, Résultat attendu, Source, Statut, Commentaire. Les ID sont de la forme `REC-001`, `REC-002`…, uniques dans le livrable.
- CA4 : Étant donné un projet dont des specs `docs/specs/*.md` contiennent des critères d'acceptation numérotés, alors chaque critère vérifiable manuellement est couvert par au moins un cas, et la colonne Source cite le chemin de la spec et l'identifiant du critère (ex. `docs/specs/004-planning.md#CA3`).
- CA5 : Étant donné un livrable `wf-specs-tickets` présent, alors chaque critère d'acceptation vérifiable manuellement de chaque ticket est couvert par au moins un cas, et la colonne Source cite le fichier, le ticket et le critère (ex. `docs/wf/specs-tickets.md#T04-CA2`).
- CA6 : Étant donné un projet sans spec `docs/specs/` ni livrable `wf-specs-tickets`, alors les cas sont déduits du code (routes, écrans, formulaires), la colonne Source cite le fichier de code, et « Périmètre et sources » avertit que les résultats attendus décrivent le comportement actuel du code et doivent être validés par le client avant la recette.
- CA7 : Étant donné le livrable, alors « Périmètre et sources » liste chaque source lue (specs, livrable `wf-specs-tickets`, code) avec son chemin.
- CA8 : Étant donné le livrable, alors chaque cas nouvellement créé porte le statut « à tester » et un commentaire vide. Les seuls statuts admis sont : à tester, conforme, non conforme, bloqué. L'outil n'attribue jamais lui-même un autre statut que « à tester ».
- CA9 : Étant donné un livrable existant dont des statuts et commentaires ont été saisis à la main, quand je relance l'outil, alors chaque cas dont la source existe toujours conserve son ID, son statut et son commentaire, et les nouveaux cas reçoivent des ID jamais utilisés auparavant dans le livrable.
- CA10 : Étant donné un cas du livrable existant dont la source a disparu (spec, ticket ou critère supprimé), quand je relance l'outil, alors le cas est retiré du tableau et listé dans « Couverture », sous « Cas retirés », avec son ID, sa fonctionnalité et son dernier statut.
- CA11 : Étant donné un critère qui n'est pas vérifiable manuellement (ex. comportement interne, performance mesurée), alors « Couverture » le liste sous « Critères non recettables manuellement » avec sa source et la raison.
- CA12 : Étant donné un projet qui contient des specs ou un livrable `wf-specs-tickets`, alors « Couverture » liste sous « Fonctionnalités sans spec » chaque route ou écran du code qu'aucune source ne mentionne, avec son fichier.
- CA13 : Étant donné une spec au statut « brouillon », alors ses cas sont générés, leur colonne Source porte la mention « spec brouillon », et « Points non déterminés » liste ces specs.
- CA14 : Étant donné le livrable, alors « Synthèse de la campagne » donne le nombre de cas par statut et le nombre total, et ces nombres correspondent exactement au contenu du tableau.
- CA15 : Étant donné un projet qui définit des rôles utilisateurs ou des données de démonstration (seeds, fixtures), alors « Prérequis » liste les rôles nécessaires à la recette et cite les fichiers de données, sans aucun identifiant de connexion, mot de passe ni jeton.
- CA16 : Étant donné une référence git passée en argument (ex. `/wf-recette v1.2.0`), quand je lance l'outil, alors seuls les specs, tickets et fichiers modifiés depuis cette référence produisent des cas (un ticket est modifié si le contenu de sa sous-section `Tnn` dans `docs/wf/specs-tickets.md` diffère entre la référence et HEAD), et « Périmètre et sources » indique la référence et son commit. Sans argument, tout le projet est couvert.
- CA17 : Étant donné une référence passée en argument qui n'existe pas dans le dépôt, alors l'outil l'indique et n'écrit ni ne modifie aucun livrable.
- CA18 : Étant donné un projet sans spec ni livrable `wf-specs-tickets` et dont la stack n'est couverte ni par JavaScript/TypeScript ni par Flutter, alors l'outil indique « stack <nom> non couverte en v1 », ne déduit aucun cas du code et n'écrit aucun livrable.
- CA19 : Étant donné un répertoire vide ou sans code source ni spec, quand je lance l'outil, alors il l'indique et n'écrit aucun livrable.
- CA20 : Étant donné le livrable, alors son en-tête est conforme à l'ADR-001 (outil, date, commit ou « hors git », mention « modifications non commitées » le cas échéant), et il ne contient aucune valeur de secret ni adresse e-mail de contributeur.
- CA21 : Étant donné un projet contenant un fichier `.env*` autre que `.env.example`, alors l'outil ne lit pas ce fichier et le livrable ne contient aucune de ses valeurs.

## Cas limites et erreurs

Couverts par CA6 (aucune spec), CA10 (source disparue), CA11 (critère non recettable), CA13 (spec brouillon), CA17 (référence inconnue), CA18, CA19 et CA21.

## Hors périmètre

- Écriture ou complétion de tests automatisés (c'est `wf-tests-manquants`).
- Rédaction des specs, des tickets et de leurs critères d'acceptation (c'est `wf-specs-tickets`), et toute modification de leur livrable.
- Description des changements d'une version (c'est `wf-release-notes`).
- Audit de performance, d'accessibilité ou de SEO (c'est `wf-audit-web`) ; vérification de sécurité (c'est `wf-revue-securite`).
- Exécution de l'application ou des cas de recette, et saisie automatique des résultats.
- Lecture d'un outil de tickets distant (Jira, GitLab, Linear…).
- Export CSV ou tableur du cahier, et modèle de procès-verbal de recette.

## Questions ouvertes

- Aucune.
