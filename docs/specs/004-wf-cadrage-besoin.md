# Spec 004 : wf-cadrage-besoin, cadrage d'un besoin client

Statut : validée
Date : 2026-10-09

## Besoin

En tant que freelance qui reçoit une demande client (brief, cahier des charges, notes d'échange), je veux en tirer un document de cadrage structuré, afin de lister clairement ce qui est demandé, ce qui ne l'est pas et ce qu'il reste à clarifier avant de chiffrer.

Le livrable s'adresse à moi en premier lieu (base de `wf-chiffrage` et `wf-specs-tickets`), et peut être partagé avec le client pour valider la compréhension du besoin. Il suit les conventions de l'ADR-001 et de son amendement 1 (entrées hors du code, saisies humaines, dépendances entre outils).

### Entrée de l'outil

L'entrée n'est pas le code du projet mais un ou plusieurs fichiers passés en argument (brief, cahier des charges, notes), en Markdown, texte brut ou PDF contenant du texte :

```
/wf-cadrage-besoin brief-fieldops.pdf notes-appel.md
```

- Le texte saisi directement dans la commande n'est pas une source : seuls des fichiers le sont.
- Le code éventuellement présent dans le projet cible n'est pas analysé.
- L'outil ne pose aucune question pendant l'exécution : il les liste dans le livrable, je les remplis à la main ou je relance avec une nouvelle source.

### Contrat avec les autres outils

Le livrable est lu par `wf-chiffrage` (spec 005) et `wf-specs-tickets` (spec 006). Conformément à l'amendement 1 de l'ADR-001, sont un contrat : le chemin `docs/wf/cadrage-besoin.md`, les noms des sections listées en CA2, les identifiants de besoins `Bnn` et de questions `Qnn`.

## Critères d'acceptation

- CA1 : Étant donné un projet cible et un fichier de brief lisible, quand je lance `/wf-cadrage-besoin <chemin du brief>` à la racine du projet, alors le fichier `docs/wf/cadrage-besoin.md` est créé et aucun autre fichier n'est modifié, y compris le fichier de brief.
- CA2 : Étant donné le livrable produit, alors il contient dans cet ordre les sections : Synthèse, Contexte et objectifs, Utilisateurs et rôles, Besoins fonctionnels, Contraintes, Hors périmètre, Hypothèses, Questions au client, Points non déterminés.
- CA3 : Étant donné le livrable, alors son en-tête est conforme à l'ADR-001 et liste en plus les sources lues, chacune désignée par son nom de fichier seul (amendement 1).
- CA4 : Étant donné le livrable, alors chaque besoin de « Besoins fonctionnels » a un identifiant unique (`B01`, `B02`…), un libellé, une priorité et au moins une source : nom du fichier, plus le numéro de page pour un PDF ou le titre de section pour un fichier Markdown.
- CA5 : Étant donné une source qui exprime la priorité d'un besoin, alors cette priorité est notée sur l'échelle « indispensable, important, souhaitable » ; étant donné une source qui ne l'exprime pas, alors la priorité est « non précisée » et aucune priorité n'est déduite.
- CA6 : Étant donné un brief contenant un qualificatif non quantifié sur la performance, le volume, le délai ou l'ergonomie (ex. « l'application doit être rapide », « beaucoup d'interventions », « simple à utiliser »), alors « Questions au client » contient une question demandant un critère mesurable pour ce qualificatif, en citant la phrase source.
- CA7 : Étant donné un brief qui ne précise pas les plateformes cibles (web, iOS, Android), alors « Questions au client » contient une question sur ce point et « Contraintes » ne mentionne aucune plateforme comme acquise.
- CA8 : Étant donné deux sources qui se contredisent (ex. le brief demande une application web seule, les notes d'appel mentionnent une application mobile), alors « Questions au client » contient une question qui cite les deux sources, et aucune des deux versions n'est retenue dans « Besoins fonctionnels » ou « Contraintes ».
- CA9 : Étant donné un élément explicitement exclu par une source (ex. « la facturation n'est pas concernée »), alors il figure dans « Hors périmètre » avec sa source.
- CA10 : Étant donné le livrable, alors chaque élément de « Hypothèses » est formulé comme une hypothèse à valider, et renvoie à la question `Qnn` qui permettrait de la lever.
- CA11 : Étant donné le livrable, alors chaque question de « Questions au client » a un identifiant unique (`Q01`, `Q02`…), le besoin `Bnn` concerné s'il y en a un, et un champ « Réponse : » vide à remplir à la main.
- CA12 : Étant donné un livrable dont j'ai rempli à la main le champ « Réponse : » d'une question, quand je relance l'outil, alors la réponse est conservée telle quelle (amendement 1, saisies humaines), et les sections concernées sont mises à jour en citant « réponse saisie à la question `Qnn` » comme source.
- CA13 : Étant donné un livrable déjà présent, quand je relance l'outil avec une nouvelle source (ex. un e-mail de réponse du client enregistré en fichier), alors la nouvelle source s'ajoute à la liste de l'en-tête, et chaque question à laquelle elle répond voit son champ « Réponse : » rempli en citant cette source, puis est traitée comme en CA12.
- CA14 : Étant donné un livrable déjà présent, quand je relance l'outil, alors un besoin ou une question conserve son identifiant, et l'identifiant d'un besoin ou d'une question retiré n'est jamais réattribué.
- CA15 : Étant donné un livrable déjà présent, quand je relance l'outil sans argument, alors il relit les sources listées dans l'en-tête et met à jour le livrable ; si l'une d'elles est introuvable, il le signale dans « Points non déterminés » et continue avec les autres.
- CA16 : Étant donné aucun argument et aucun livrable existant, quand je lance l'outil, alors il indique la syntaxe attendue et n'écrit aucun livrable.
- CA17 : Étant donné un chemin qui n'existe pas, un format autre que Markdown, texte ou PDF (ex. `.docx`), ou un PDF sans texte extractible (document scanné), quand je lance l'outil, alors il l'indique en nommant le fichier en cause ; si aucune source n'est lisible, il n'écrit aucun livrable, sinon il continue avec les sources lisibles et signale la source écartée dans « Points non déterminés ».
- CA18 : Étant donné le texte d'une demande saisi dans la commande au lieu d'un chemin de fichier, quand je lance l'outil, alors il indique que seules des sources sous forme de fichier sont acceptées et n'écrit aucun livrable.
- CA19 : Étant donné une source contenant des adresses e-mail ou des numéros de téléphone, alors le livrable n'en contient aucun.
- CA20 : Étant donné une source rédigée dans une autre langue que le français, alors le livrable est rédigé en français et les citations éventuelles restent dans la langue d'origine.
- CA21 : Étant donné le répertoire de la fixture `tests/fixtures/fieldops-brief/` (projet sans code source), quand je lance l'outil avec le brief qu'elle contient, alors le livrable est créé normalement (amendement 1).
- CA22 : Étant donné un projet cible qui contient du code source, alors le livrable ne cite aucun fichier de code et n'affirme rien sur l'existant.
- CA23 : Étant donné une information absente de toutes les sources (ex. hébergement, date de mise en production), alors elle n'est affirmée nulle part dans le livrable ; si elle est nécessaire au chiffrage, elle fait l'objet d'une question dans « Questions au client ».

## Cas limites et erreurs

Couverts par CA5 à CA8, CA15 à CA23.

## Hors périmètre

- Chiffrage en jours ou en montant (c'est `wf-chiffrage`).
- Découpage en tickets avec critères d'acceptation (c'est `wf-specs-tickets`).
- Compte rendu de la réunion ou de l'appel dont sont tirées les notes (c'est `wf-compte-rendu`).
- Diagnostic du code existant (c'est `wf-analyse-projet`).
- Proposition de solution technique ou d'architecture.
- Rédaction d'une proposition commerciale ou d'un devis.
- Entretien interactif pendant l'exécution.
- Lecture de formats autres que Markdown, texte et PDF (`.docx`, `.eml`…) : à convertir au préalable.

## Questions ouvertes

- Aucune.
