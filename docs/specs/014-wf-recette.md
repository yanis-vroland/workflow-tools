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

## Amendement 1 (proposé)

Précisions issues de l'implémentation, à valider. Chacune complète le CA indiqué.

- CA3 : le tableau des cas est trié par identifiant ; dans la colonne Étapes, les actions sont numérotées et séparées par `<br>` ; une barre verticale qui figurerait dans une cellule est remplacée par « / ».
- CA4 : chaque cas a une seule source ; un critère qui mêle plusieurs vérifications peut produire plusieurs cas. Une spec sans critère numéroté est citée dans « Périmètre et sources » et dans « Points non déterminés », sans produire de cas.
- CA4, CA6 : l'outil travaille en mode specs dès qu'il existe au moins une spec à critères numérotés ou un ticket dans le livrable `wf-specs-tickets` ; le code ne sert alors qu'aux prérequis et à la couverture. Sinon, il déduit les cas du code.
- CA6 : en mode code, la colonne Source cite le fichier de code, éventuellement suivi d'un numéro de ligne, et « Fonctionnalités sans spec » porte la mention « Sans objet : aucune spec ni livrable wf-specs-tickets, les cas sont déduits du code. »
- CA9 : l'en-tête porte une ligne « Dernier identifiant attribué : REC-nnn », qui vaut le plus grand identifiant jamais attribué dans le livrable, même retiré depuis ; un nouveau cas reçoit le suivant, et un identifiant retiré n'est jamais réattribué, même pour combler un trou.
- CA9 : deux sources sont identiques si elles citent le même chemin et le même critère, avec ou sans la mention « spec brouillon » ; plusieurs cas de même source sont rapprochés par leur fonctionnalité. Fonctionnalité, Préconditions, Étapes et Résultat attendu d'un cas conservé sont mis à jour si sa source a changé ; son ID, son statut et son commentaire sont recopiés mot pour mot.
- CA9, CA16 : « Couverture » contient une sous-section « Cas hors campagne », entre « Fonctionnalités sans spec » et « Cas retirés ». Elle résout le conflit entre CA9 (tout cas dont la source existe conserve ses saisies) et CA16 (seuls les éléments modifiés depuis la référence produisent des cas) : un cas existant dont la source existe toujours mais n'entre pas dans le périmètre de la campagne (hors des changements depuis la référence, ou devenu non vérifiable manuellement) quitte le tableau et y est listé avec son ID, sa fonctionnalité, sa source, son dernier statut et son dernier commentaire, recopiés mot pour mot. À la relance suivante, une entrée de « Cas hors campagne » est un cas existant : elle revient au tableau avec son ID, son statut et son commentaire si elle rentre dans le périmètre, est reconduite telle quelle sinon, et passe sous « Cas retirés » si sa source a disparu.
- CA9 : dans une entrée de « Cas hors campagne », le point qui termine l'entrée ne fait pas partie du commentaire ; un commentaire qui revient au tableau y est identique, caractère pour caractère, à celui qu'avait le tableau.
- CA10 : une source a disparu quand la spec, le ticket ou le critère est supprimé ou renuméroté, ou, en mode code, quand le fichier de code est supprimé ; « Cas retirés » cite aussi l'ancienne source du cas.
- CA11 : un critère est vérifiable manuellement si une personne peut le constater en utilisant l'application, par ce qu'elle affiche, produit ou envoie. Ne l'est pas un critère qui porte sur un comportement interne non observable depuis l'application, sur une performance qui exige une mesure outillée, ou sur une propriété du code lui-même.
- CA12 : une route ou un écran est mentionné par une source si un critère, un besoin ou un ticket décrit ce qu'il fait ; une simple précondition d'accès ou le nom d'une entité ne suffit pas. Avec une référence, « Fonctionnalités sans spec » ne porte que sur les fichiers de code modifiés depuis elle. Si des specs existent mais que la stack n'est pas couverte, la sous-section indique « non déterminé (stack <nom> non couverte en v1) ».
- CA13 : la mention « (spec brouillon) » suit la source dans la colonne Source ; « Points non déterminés » liste chaque spec brouillon comme « spec au statut brouillon, cas à confirmer quand elle sera validée ».
- CA14 : la synthèse donne un nombre pour chacun des quatre statuts admis, zéro compris ; les cas hors campagne et les cas retirés ne sont pas comptés.
- CA15 : quand un mot de passe de démonstration est fourni par une variable d'environnement, « Prérequis » nomme au plus la variable, jamais sa valeur. Sans rôle ni donnée de démonstration identifiés, « Prérequis » l'écrit « non déterminé » et « Points non déterminés » le reprend.
- CA16 : « Périmètre et sources » indique, sur une même ligne, la référence et son commit (hash court). Les fichiers modifiés sont ceux qui diffèrent entre la référence et HEAD : les modifications non commitées n'en font pas partie, et la ligne de la référence le précise quand l'en-tête porte « modifications non commitées ».
- CA16 : un ticket absent à la référence est un ticket modifié ; si le livrable `wf-specs-tickets` n'existait pas à la référence, tous ses tickets sont modifiés. En mode specs, un fichier de code modifié ne produit pas de cas.
- CA16 : quand aucun élément n'a changé depuis la référence, le tableau garde son en-tête, suivi de « Aucun cas pour cette campagne. »
- CA16, CA17 : une référence n'est admise que si elle commence par une lettre ou un chiffre et ne contient ensuite que des lettres, chiffres, `.`, `_`, `/`, `-`, `~` et `^` ; sinon, elle est traitée comme introuvable, sans qu'aucune commande ne la reçoive. Une valeur qui commence par `-` n'est jamais insérée dans une commande git, même si c'est un nom de branche valide ; chaque commande git qui reçoit la référence la place en plus après `--end-of-options`.
- CA17 : hors dépôt git, toute référence est introuvable. Le message est : « Référence <ref> introuvable dans le dépôt : aucun cahier de recette n'a été écrit ni modifié. »
- CA18 : le message est : « Stack <nom> non couverte en v1 : aucun cas n'est déduit du code et aucun cahier de recette n'a été écrit. » Un projet d'une stack non couverte qui contient des specs ou un livrable `wf-specs-tickets` produit un cahier à partir de ces sources.
- CA19 : un répertoire qui ne contient que des documents sans code ni spec est traité comme un répertoire vide. Le message est : « Aucun code source ni aucune spec trouvé dans ce répertoire : aucun cahier de recette n'a été écrit. »
- Cas limite : les quatre sous-sections de « Couverture » sont toujours présentes, avec « - Aucun. » quand elles sont vides.
- Cas limite : le message de fin donne le chemin du livrable, s'il a été créé ou mis à jour, le nombre de cas (dont nouveaux), de cas retirés et de critères non recettables manuellement, ou, si rien n'a été écrit, la raison.
