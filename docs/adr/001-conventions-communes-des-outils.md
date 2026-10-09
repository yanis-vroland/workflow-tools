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
2. **Evals** (`evals/`, via la commande `claude plugin eval`, intégrée à Claude Code et disponible à la date de cet ADR ; un premier cas sur FieldOps sert d'essai avant d'écrire les autres) : chaque outil lancé sur un projet fictif, **FieldOps** (`tests/fixtures/fieldops/`), avec des correcteurs vérifiant le livrable (emplacement, sections, absence d'invention, absence de secret). Les appels réseau y sont simulés pour garder des résultats reproductibles. Ils appellent un modèle : lancés à la main avant chaque PR d'outil, et en CI uniquement sur un label `evals`, pour maîtriser le coût. En CI, ils utilisent le secret `CLAUDE_CODE_OAUTH_TOKEN` déjà configuré pour la revue IA, et ne tournent que sur des PR de ce dépôt, jamais sur une PR venant d'un fork.

La fixture FieldOps est un petit projet web volontairement imparfait (dette, dépendance obsolète, test manquant) pour donner prise aux outils de diagnostic.

Aucun fichier `.env*` autre que `.env.example` n'est commité dans la fixture, conformément aux interdits du CLAUDE.md. Pour vérifier qu'un outil ne lit pas un fichier d'environnement, l'eval copie la fixture dans un répertoire temporaire et y génère à l'exécution un fichier d'environnement contenant un marqueur reconnaissable (ex. `FIELDOPS_FAUX_SECRET_7f3a`), volontairement sans rapport avec un vrai format de clé pour ne pas déclencher les scanners de secrets, puis vérifie que ce marqueur n'apparaît pas dans le livrable.

## Conséquences

- Positives : tous les outils se comportent de la même façon ; le livrable est facile à repérer, à ignorer dans git ou à supprimer ; les tests structurels sont rapides et gratuits ; les evals vérifient la qualité réelle.
- Négatives : les evals ne sont pas déterministes (un correcteur modèle peut varier) et coûtent du quota ; ils ne bloquent donc pas chaque PR. Le contrôle par mutation ne s'applique qu'aux tests structurels.
- Une fixture à maintenir, qui grandira avec les outils (projet mobile pour `wf-publication-store`, etc.).

## Alternatives écartées

- **Écrire dans `docs/` directement** : mieux intégré, mais risque d'écraser la documentation existante du projet client.
- **Écrire hors du projet** (`~/wf-livrables/`) : ne touche jamais au dépôt client, mais le livrable n'est plus versionné avec le projet.
- **Fichier daté à chaque exécution** : historique visible sans git, mais accumulation de fichiers et pas de mise à jour incrémentale.
- **Tests structurels seuls** : ne vérifient pas la qualité du livrable.
- **Evals à chaque PR** : plus sûr, mais coût et lenteur à chaque push.
