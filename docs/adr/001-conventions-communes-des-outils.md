# ADR-001 : conventions communes des outils et stratégie de test des skills

Statut : accepté
Date : 2026-10-09

## Contexte

Chaque outil du plugin est une skill (`skills/wf-<outil>/SKILL.md`) lancée dans un projet cible, qui y écrit un livrable. Avant d'écrire le premier outil, il faut fixer ce que tous partagent : l'emplacement du livrable, le comportement face à un livrable existant, et la manière de tester une skill.

Ce dernier point est structurant : une skill est un prompt en Markdown, pas du code exécutable. Le test-first imposé par le CLAUDE.md (ADR-003 du template) doit donc être adapté.

## Décision

### Livrable

- Chaque outil écrit un fichier Markdown dans `docs/wf/<outil>.md` du projet cible, où `<outil>` est le nom sans le préfixe `wf-` (ex. `docs/wf/analyse-projet.md`).
- Quand le livrable est trop volumineux pour un seul fichier, la spec de l'outil peut prévoir un dossier `docs/wf/<outil>/` avec un `index.md` comme point d'entrée. Les deux formats ne coexistent jamais pour un même outil.
- Le dossier `docs/wf/` est créé s'il n'existe pas. Aucun autre fichier du projet cible n'est modifié.
- L'en-tête du livrable indique l'outil, la date et le commit analysé (`git rev-parse --short HEAD` si le projet est un dépôt git), suivi de la mention « modifications non commitées » si le répertoire de travail n'est pas propre.
- Si le livrable existe déjà, l'outil le relit et le met à jour : il conserve ce qui reste vrai, corrige ce qui a changé et met à jour la date. L'historique est porté par git.
- Le livrable est rédigé en français.

### Honnêteté du livrable

- Toute affirmation sur le projet s'appuie sur un fichier lu ; les chemins sont cités.
- Ce qui n'a pas pu être établi est signalé comme tel (« non déterminé »), jamais deviné.
- Aucun secret n'est recopié : les fichiers `.env*` (hors `.env.example`) ne sont pas lus.
- Aucune donnée personnelle superflue : pas d'adresse e-mail de contributeur dans un livrable.

### Accès réseau

- Un outil peut interroger des sources publiques en lecture (registres de paquets, avis de sécurité) si sa spec le prévoit. Il n'envoie jamais de code ni de contenu du projet, seulement des noms et versions de paquets.
- Si le réseau est indisponible, l'outil se replie sur les informations locales, le signale dans le livrable et ne s'interrompt pas.

### Tests à deux niveaux

1. **Tests structurels** (`tests/skills.sh`, bash, sans modèle) : pour chaque `skills/wf-*/SKILL.md`, frontmatter valide (`name` égal au nom du dossier, `description` non vide), et présence des consignes communes ci-dessus. Lancés en CI à chaque PR avec les autres tests de garde-fous.
2. **Evals** (`evals/`, via la commande `claude plugin eval`, intégrée à Claude Code et disponible à la date de cet ADR ; un premier cas sur FieldOps sert d'essai avant d'écrire les autres) : chaque outil lancé sur un projet fictif, **FieldOps** (`tests/fixtures/fieldops/`), avec des correcteurs vérifiant le livrable (emplacement, sections, absence d'invention, absence de secret). Les appels réseau y sont réels, car `claude plugin eval` ne simule que les serveurs MCP. Les correcteurs ne dépendent donc jamais d'une valeur publique qui évolue (dernière version publiée, avis de sécurité, exigences des stores) : ils vérifient la présence et la forme de l'information (ex. une version plus récente que celle installée, citée avec sa source), pas une valeur exacte. Correction validée le 2026-10-09. Ils appellent un modèle : lancés à la main avant chaque PR d'outil, et en CI uniquement sur un label `evals`, pour maîtriser le coût. En CI, ils utilisent le secret `CLAUDE_CODE_OAUTH_TOKEN` déjà configuré pour la revue IA, et ne tournent que sur des PR de ce dépôt, jamais sur une PR venant d'un fork.

La fixture FieldOps est un petit projet web volontairement imparfait (dette, dépendance obsolète, test manquant) pour donner prise aux outils de diagnostic.

Aucun fichier `.env*` autre que `.env.example` n'est commité dans la fixture, conformément aux interdits du CLAUDE.md. Pour vérifier qu'un outil ne lit pas un fichier d'environnement, l'eval copie la fixture dans un répertoire temporaire et y génère à l'exécution un fichier d'environnement contenant un marqueur reconnaissable (ex. `FIELDOPS_FAUX_SECRET_7f3a`), volontairement sans rapport avec un vrai format de clé pour ne pas déclencher les scanners de secrets, puis vérifie que ce marqueur n'apparaît pas dans le livrable.

## Amendement 1 : extension aux 16 outils

Statut : accepté
Date : 2026-10-09

La rédaction des specs 003 à 016 a montré que plusieurs outils ne partent pas du code (brief client, notes de réunion), produisent des livrables qui s'accumulent, ou gagneraient à toucher au projet. Cet amendement complète la décision ci-dessus ; en cas de conflit, il prévaut.

### Organisation des livrables selon leur nature

- **Fichier unique mis à jour** (règle par défaut) : tous les outils, sauf les deux ci-dessous.
- **Dossier, un fichier par occurrence** : `wf-compte-rendu` écrit `docs/wf/compte-rendu/AAAA-MM-JJ-<sujet>.md` pour chaque réunion, et maintient `docs/wf/compte-rendu/index.md` qui les liste.
- **Fichier unique cumulatif** : `wf-release-notes` ajoute une section par version en tête de `docs/wf/release-notes.md`, sans réécrire les sections des versions précédentes.
- Le découpage en dossier pour un livrable volumineux (spec 002, CA10) reste possible quand la spec le prévoit.

### Saisies humaines

- Quand un livrable contient des champs à remplir à la main (statuts de recette, checklist de passation, réponses aux questions de cadrage), une relance de l'outil conserve ces saisies telles quelles.

### Écriture limitée à `docs/wf/` en v1

- Aucun outil ne modifie un fichier hors de `docs/wf/`, ni n'exécute le projet, ses tests ou son installation, ni ne crée de branche ou de commit. Les productions qui toucheraient au projet (squelettes de tests, plan de montée de version, brouillon des fiches store) restent dans le livrable. Cette règle sera réexaminée après la v1.

### Entrées hors du code

- Un outil peut prendre en entrée des fichiers passés en argument (brief, notes, transcription), y compris hors du projet. Le livrable cite leur nom de fichier seul, jamais un chemin absolu, pour ne pas exposer l'arborescence de la machine.
- Les outils dont l'entrée n'est pas le code (cadrage, chiffrage, tickets, compte rendu) produisent leur livrable même dans un répertoire sans code source.
- Exceptions prévues par leur spec : `wf-compte-rendu` accepte aussi des notes collées dans la commande, et `wf-compte-rendu` comme `wf-rapport-avancement` peuvent poser des questions pendant l'exécution (date de réunion, doublon, période). Les autres outils ne prennent que des fichiers et ne posent pas de question.

### Stack non couverte

- Les outils qui décrivent un projet (`wf-onboarding`, `wf-passation`) produisent un livrable réduit, limité à ce qui ne dépend pas de la stack, et le signalent. Les outils qui exigent une stack connue (`wf-recette` faute de spec, `wf-publication-store`) n'écrivent aucun livrable et l'indiquent.

### Dépendances entre outils

- Un outil peut lire le livrable d'un autre outil dans `docs/wf/` si sa spec le prévoit. Il ne le modifie jamais. Les noms de fichiers et de sections des livrables cités par une autre spec deviennent un contrat : les changer impose de mettre à jour les specs qui les lisent.

### Accès réseau étendu

- En plus des registres de paquets et des avis de sécurité, un outil peut lire, si sa spec le prévoit, des documentations publiques : notes de version, guides de migration, calendriers de fin de support (endoflife.date), documentation officielle des stores.
- `wf-audit-web` peut auditer une URL fournie en argument avec Lighthouse, s'il est déjà installé, sans l'installer. Sans URL ou sans Lighthouse, il audite le code seul.
- Aucun outil ne se connecte à un service privé (outil de tickets, plateforme de transcription, compte de store) en v1.

### Stacks couvertes en v1

- Web JavaScript/TypeScript (npm, pnpm, yarn) et Flutter (pub). Les autres stacks sont détectées et signalées comme « non couvertes » sans analyse approfondie.

### Fixtures

- `tests/fixtures/fieldops/` : l'univers FieldOps, avec une application web JS/TS volontairement imparfaite, une application compagnon Flutter, et des specs internes à critères numérotés (dont une en brouillon) pour `wf-recette`.
- `tests/fixtures/fieldops-brief/` : un projet pas encore démarré, contenant un brief client et des notes de réunion fictifs, pour les outils d'avant-vente et de pilotage.

## Amendement 2 : fichiers non Markdown et encadrés « À décider »

Statut : accepté
Date : 2026-10-12

Deux outils s'ajoutent aux 16 : `wf-modele-donnees` (spec 017), qui passe d'une analyse à un modèle de données puis à un schéma de base, et `wf-exploitation` (spec 018), guide d'exploitation tiré du code. Le premier livre des fichiers directement utilisables par le développeur (schéma, migration, requêtes), que la règle « un fichier Markdown » ne permet pas, et il a besoin de faire trancher des choix au chef de projet. Cet amendement complète la décision et l'amendement 1 ; en cas de conflit, il prévaut.

### Fichiers non Markdown dans un livrable en dossier

- Quand sa spec le prévoit, un outil dont le livrable est un dossier `docs/wf/<outil>/` peut y écrire des fichiers non Markdown (ex. `.sql`, `.prisma`, `.ts`, `.dart`), à côté de l'`index.md`.
- L'`index.md` reste le point d'entrée : il porte l'en-tête commun (outil, date, commit) et liste chaque fichier du dossier avec son rôle.
- Chaque fichier non Markdown commence, si son format admet les commentaires, par un commentaire qui nomme l'outil et renvoie à l'`index.md`.
- Les règles d'honnêteté s'appliquent à ces fichiers comme au Markdown : aucun secret, et des données de test uniquement fictives.
- Ces fichiers restent dans `docs/wf/` (amendement 1) : le développeur les copie lui-même dans le projet. Si un fichier du dossier n'a plus lieu d'être à la relance, l'outil le signale dans l'`index.md` au lieu de le supprimer.

### Aucune exécution

- Les fichiers produits (migrations, requêtes, données de test, scripts) sont écrits, jamais exécutés, y compris dans une base de données jetable. L'exécution dans un environnement isolé, qui permettrait de prouver qu'un schéma ou une migration fonctionne, sera réexaminée après la v1, avec la règle d'écriture limitée à `docs/wf/`.

### Encadrés « À décider »

Un encadré « À décider » présente un choix que l'outil ne peut pas trancher seul. Il se distingue d'une question au client (format `Qnn` de la spec 004), qui demande un fait : l'encadré propose des options identifiées, chacune avec ses conséquences.

- Chaque encadré a un identifiant unique et stable (`D01`, `D02`…), jamais réattribué après retrait, un titre, le contexte qui rend le choix nécessaire avec sa source, au moins deux options avec leurs conséquences, et un champ « Décision : » vide à remplir à la main.
- L'outil ne remplit jamais le champ « Décision : ». Une option ne peut être recommandée que si la spec de l'outil le prévoit, et la recommandation est alors justifiée par une source.
- À la relance, le champ « Décision : » est conservé tel quel (amendement 1, saisies humaines). Une décision saisie est appliquée dans le reste du livrable, citée comme source (« décision saisie en `Dnn` »). Si les options ou le contexte ont changé depuis, l'outil conserve la décision et le signale au lieu de l'effacer.
- La convention sert d'abord à `wf-modele-donnees`, puis à `wf-passation` et à de futurs outils, dès que leur spec le prévoit.

Exemple sur FieldOps :

```markdown
> **D01 — Retrait d'un technicien**
>
> Contexte : les interventions référencent un technicien (`interventions.technician_id`, source : `src/db/schema.sql`) ; le brief ne dit pas ce qu'il advient d'un technicien qui quitte l'entreprise.
>
> - **Option 1 : suppression définitive.** Conséquence : ses interventions passées perdent leur technicien, ou doivent être supprimées avec lui.
> - **Option 2 : désactivation** (champ `active_until`). Conséquence : l'historique est conservé ; chaque liste de techniciens doit filtrer les inactifs.
>
> Décision :
```

## Conséquences

- Positives : tous les outils se comportent de la même façon ; le livrable est facile à repérer, à ignorer dans git ou à supprimer ; les tests structurels sont rapides et gratuits ; les evals vérifient la qualité réelle.
- Négatives : les evals ne sont pas déterministes (un correcteur modèle peut varier) et coûtent du quota ; ils ne bloquent donc pas chaque PR. Le contrôle par mutation ne s'applique qu'aux tests structurels.
- Deux fixtures à maintenir (FieldOps web et Flutter, FieldOps brief), qui grandiront avec les outils.
- Amendement 1 : en v1, les outils restent en lecture seule sur le projet, au prix d'un peu de travail manuel (copier les squelettes de tests, appliquer le plan de montée) ; en contrepartie, aucun risque d'altérer un projet client.
- Amendement 2 : le développeur reçoit des fichiers prêts à copier, mais non éprouvés tant que rien n'est exécuté ; le livrable doit le dire. Les encadrés « À décider » ajoutent un format de saisie humaine que les tests structurels et les evals des outils concernés devront couvrir.

## Alternatives écartées

- **Écrire dans `docs/` directement** : mieux intégré, mais risque d'écraser la documentation existante du projet client.
- **Écrire hors du projet** (`~/wf-livrables/`) : ne touche jamais au dépôt client, mais le livrable n'est plus versionné avec le projet.
- **Fichier daté à chaque exécution** : historique visible sans git, mais accumulation de fichiers et pas de mise à jour incrémentale.
- **Tests structurels seuls** : ne vérifient pas la qualité du livrable.
- **Evals à chaque PR** : plus sûr, mais coût et lenteur à chaque push.
