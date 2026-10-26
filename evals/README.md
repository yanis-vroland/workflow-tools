# Evals des skills

Evals lancées avec `claude plugin eval` (ADR-001, tests à deux niveaux). Chaque dossier est un cas : `case.yaml` (configuration et scaffold), `prompt.md`, et `graders/`.

## Lancer en local

Les cas se lancent en deux passes, selon leur tag réseau (voir « Réseau ») :

```bash
# Registres joignables (tag reseau)
claude plugin eval . --scaffold --trust-plugin --no-publish --judge-model sonnet --ablation none --tag reseau \
  --allow-tools Write Bash "WebFetch(domain:registry.npmjs.org)" "WebFetch(domain:pub.dev)" "WebFetch(domain:api.osv.dev)" "WebFetch(domain:endoflife.date)" "WebFetch(domain:storage.googleapis.com)" "WebFetch(domain:developer.android.com)" "WebFetch(domain:developer.apple.com)"

# Aucun réseau (tag hors-reseau)
claude plugin eval . --scaffold --trust-plugin --no-publish --judge-model sonnet --ablation none --tag hors-reseau \
  --allow-tools Write Bash
```

- `--scaffold` : nécessaire pour que chaque cas reconstruise sa fixture (`tests/fixtures/build-fieldops.sh`).
- `--allow-tools Write Bash` : les outils déclarés dans `allowed_tools` doivent aussi être accordés au lancement.
- `--no-publish` : toujours. Le rapport reste local, dans `evals/results/` (ignoré par git).
- `--judge-model sonnet` : les correcteurs `llm` sont jugés par Sonnet (haiku par défaut, trop peu fiable).
- `--ablation none` : pas de bras sans plugin. Sans le plugin, `/wf-<outil>` n'est qu'une commande inconnue : ce bras doublerait le coût sans rien mesurer.
- `--case <nom>` pour un seul cas, `--runs 1` pour un essai rapide.
- Pas de correcteur `tool_used: Skill` : une skill lancée par sa commande (`/wf-<outil>`) ne passe pas par l'outil `Skill` (0 appel constaté en eval), la preuve du déclenchement repose sur le livrable.

## Réseau

Dès que `Bash` est accordé, ses commandes tournent dans le bac à sable de Claude Code, dont l'accès réseau est limité aux domaines accordés par `--allow-tools "WebFetch(domain:…)"`. Sans ces autorisations, aucun registre n'est joignable. D'où deux passes :

- tag `reseau` : le cas a besoin des registres (npm, pub.dev), de la base d'avis OSV.dev (`api.osv.dev`), des calendriers de versions (endoflife.date, versions publiées de Flutter sur `storage.googleapis.com`), de la documentation officielle des stores (developer.android.com ou developer.apple.com) ;
- tag `hors-reseau` : le cas tourne sans aucun réseau, y compris ceux qui exigent un registre injoignable.

Chaque cas porte exactement un de ces deux tags ; `.github/scripts/verifier-tags-evals.sh` le vérifie en CI, sinon le cas ne serait jamais lancé.

Les variables d'environnement ne permettent pas de couper un registre : l'environnement du scaffold n'est pas transmis à la session, et `execution.env` n'accepte que des variables `EVAL_*`.

## Modèle

Les cas des skills s'exécutent avec Sonnet (`execution.model`), plus représentatif de l'usage réel ; `socle-fixture`, qui ne teste aucune skill, garde Haiku.

## En CI

Le workflow `.github/workflows/evals.yml` ne tourne que sur une PR de ce dépôt portant le label `evals`. Il lance les deux passes par `.github/scripts/evals-avec-relance.sh`, qui relance une fois, seul, chaque cas en échec : les juges `llm` sont bruités sur les longs livrables (un verdict isolé, démenti en rejouant), la CI ne tombe donc que si un cas échoue deux fois de suite. Les résultats JSON sont publiés en artefact.

## Cas

- `socle-fixture` : cas d'essai de la chaîne, sans skill. Vérifie que le scaffold reconstruit FieldOps (historique, tags, faux secret) et que les graders lisent un livrable sous `docs/wf/` et la trace.

### wf-doc-projet

Spec 002, lancée par `/wf-doc-projet`, tous les cas `hors-reseau` (tag `wf-doc-projet` pour ne lancer qu'eux). Chaque grader, déclaré dans `case.yaml`, porte l'identifiant du CA qu'il vérifie (`ca04-…`).

| Cas | Projet de départ | CA |
|---|---|---|
| `doc-projet-ca09-fichier-unique` | FieldOps web seul, propre | CA1 à CA6, CA8, CA9, CA11, CA13 |
| `doc-projet-ca10-monorepo` | FieldOps complet (web et Flutter), propre | CA10 (cas limite monorepo), CA1, CA3 à CA6, CA8, CA13 |
| `doc-projet-ca04-tableau-des-variables` | FieldOps web seul, plus un paiement par carte via le SDK Stripe (commit rejouable), propre | CA4 (tableau des variables : chaque colonne, « non déterminé », aucun service ni procédure inventés), CA1 |
| `doc-projet-ca08-modifications-non-commitees` | FieldOps web seul, `--dirty` | CA8 |
| `doc-projet-ca07-mise-a-jour` | FieldOps web seul et livrable fichier déjà commité | CA7, CA4 (ancienne liste des variables remplacée par le tableau) |
| `doc-projet-ca12-dossier-vers-fichier` | FieldOps web seul et ancien livrable dossier | CA12 (cas limite) |
| `doc-projet-ca12-fichier-vers-dossier` | FieldOps complet et ancien livrable fichier | CA12 (cas limite) |
| `doc-projet-ca14-repertoire-vide` | répertoire vide | CA14 (cas limite) |
| `doc-projet-ca14-sans-code-source` | FieldOps brief (documents seuls) | CA14 (cas limite) |
| `doc-projet-ca15-sans-commande-de-lancement` | code TypeScript sans `package.json` ni commande | CA15 (cas limite) |

Les hash de commit attendus dans les en-têtes sont ceux des scaffolds, rejouables : `2fc99c0` (FieldOps complet), `be04389` (web seul), `81c55c7` (cas CA7). Une modification de la fixture les change : mettre à jour les graders `ca08-…` et `ca07-en-tete-…`.

Limite : `file_exists` ne voit que les fichiers créés pendant l'exécution. La suppression de l'ancien format (CA12), créé par le scaffold, est donc vérifiée par la commande de suppression observée dans la trace, pas par l'absence du fichier.
### wf-onboarding

Spec 003, tous les cas `hors-reseau`. Chaque correcteur porte dans son nom le critère qu'il vérifie (`ca07-…`).

Tous les cas portent `ca14-aucune-commande-executee` : Bash ne sert qu'à `git rev-parse --short HEAD`, `git status --porcelain` et `date +%F` (liste blanche).

- `onboarding-fieldops` : FieldOps complet (CA1 à CA9, CA11, CA12 sans doc-projet, CA13 à CA15, CA20 à CA22) ;
- `onboarding-modifs-non-commitees` : arbre de travail modifié (CA15) ;
- `onboarding-doc-projet-fichier`, `onboarding-doc-projet-dossier` : livrable `wf-doc-projet` présent, dans ses deux formats (CA12) ;
- `onboarding-mise-a-jour` : guide déjà présent, relance (CA16) ;
- `onboarding-repertoire-vide`, `onboarding-sans-code-source` : aucun livrable (CA17) ;
- `onboarding-stack-non-couverte` : projet Python fictif (CA18) ;
- `onboarding-projet-minimal` : projet TypeScript hors git sans commande d'installation, version, tests, conventions ni lancement (CA3, CA4, CA5, CA10, CA11, CA15, CA19) ;
- `onboarding-conventions` : `CONTRIBUTING.md` (branches, commits), commitlint, hook husky, lint et format (CA9) ;
- `onboarding-conteneurs-par-defaut` : conteneurs et voie native, README muet sur les deux : repli sur la voie par conteneurs (CA7).

### wf-analyse-projet

Dossier `analyse-projet/` (spec 001). Chaque correcteur porte dans son nom l'identifiant du critère d'acceptation qu'il vérifie (`ca3-…`) ; les correcteurs `…-temoin-…` vérifient que le scénario a bien été mis en place.

| Dossier | Cas | Tag | Critères |
|---|---|---|---|
| `nominal/` | FieldOps, git, arbre propre, faux secret, registres joignables | `reseau` | CA1 à CA3, CA5 à CA11, CA13, CA17, CA19 |
| `ca4-registre-injoignable/` | registres injoignables | `hors-reseau` | CA4 |
| `ca12-relance/` | livrable précédent commité | `hors-reseau` | CA12 |
| `ca13-arbre-modifie/` | modification non commitée | `hors-reseau` | CA13 |
| `ca14-repertoire-vide/`, `ca14-sans-code-source/` | répertoire vide ; brief et notes sans code | `hors-reseau` | CA14 |
| `ca15-hors-depot/` | copie de FieldOps sans git | `hors-reseau` | CA15 |
| `ca15-depot-parent-non-suivi/` | FieldOps sous un dépôt git parent, avec commits, qui ne le suit pas | `hors-reseau` | CA15 (frontière de CA20) |
| `ca16-historique-tronque/` | clone superficiel (5 commits) | `hors-reseau` | CA16 |
| `ca18-projet-volumineux/` | FieldOps et 2 000 modules générés sous `src/legacy/` | `hors-reseau` | CA18 |
| `ca20-sous-dossier/` | FieldOps dans un sous-dossier d'un dépôt git, commits plus récents hors du sous-dossier | `hors-reseau` | CA20 |
| `lockfile-piege/` | FieldOps dont trois dépendances (manifeste et lockfile) portent un nom piégé : `x'$(touch pwned)'`, puis `WF_NPM_5e1a` (délimiteur public du heredoc) suivi de `touch pwned` | `hors-reseau` | CA3 (amendement : noms transmis par le heredoc, nom invalide ou égal au délimiteur jamais écrit dans une commande, nom piégé signalé sur sa ligne) |

CA18 : « aucune conclusion sur les dossiers non lus » est vérifié par trois motifs bornés à leur section (aucune mention du mot `legacy`, sous quelque forme de chemin, dans « Dette et risques » ni « Sécurité » ; ailleurs, hors « Activité du dépôt » et « Points non déterminés », chaque ligne qui le cite dit qu'il n'a pas été lu ou qu'il est exclu, par des expressions précises : « hors de la lecture », « (hors … », « exclu » en mot entier…), au lieu d'un juge `llm` bruité sur ce long livrable. La vérification se fait ligne à ligne : une ligne qui cite le dossier comme exclu peut, en théorie, porter aussi une conclusion.

CA8 : « niveau et fichier pour chaque risque » est vérifié par un motif ligne à ligne sur « Dette et risques » (chaque élément de liste commence par **élevé**, **moyen** ou **faible** et cite un fichier entre accents graves), au lieu d'un juge `llm` bruité sur ce long livrable.

CA4 : le registre est coupé par le bac à sable (passe `hors-reseau`, sans autorisation WebFetch). Le témoin `ca4-temoin-echec-reseau` exige dans la trace la sortie d'une interrogation échouée (`<paquet> injoignable (curl <code>)`, ou `curl: (<code>)`) : sans elle, le registre n'a pas été constaté injoignable et le cas ne prouve rien. Le scaffold écrit aussi un `.npmrc` projet vers un registre injoignable (`127.0.0.1:9`), exclu par `.git/info/exclude` pour garder l'arbre propre : la commande de la skill (`curl`) l'ignore, il ne vise qu'un modèle qui passerait par `npm view` ou `npm outdated`.

CA15 et CA20 : seul un sous-dossier effectivement suivi par un dépôt qui a des commits relève de CA20. `claude plugin eval` crée lui-même un dépôt git vide dans le dossier parent de la session : `ca15-hors-depot` couvre donc aussi le dépôt parent sans commit, et `ca15-depot-parent-non-suivi` le dépôt parent avec commits qui ne suit pas le projet (même montage `core.worktree` que CA20).

CA20 : le répertoire de la session est imposé par `claude plugin eval` et le scaffold n'écrit rien au-dessus. Le dépôt est donc construit avec `core.worktree` : répertoire git dans le répertoire de la session, racine de travail dans son parent, dont la session est le sous-dossier (`git rev-parse --show-prefix` non vide). Seul ce sous-dossier est extrait (`sparse-checkout`). L'historique de FieldOps y est réécrit, suivi de 12 commits plus récents dans `plateforme/` (hors du sous-dossier, une cinquième autrice) : dernier commit du dépôt 2026-10-06, du sous-dossier 2026-09-29. Les hash dépendent du nom du répertoire de la session et ne sont pas figés.

### wf-recette

Spec 014, lancée par `/wf-recette` (ou `/wf-recette <référence>`), tous les cas `hors-reseau` (tag `wf-recette` pour ne lancer qu'eux). Chaque correcteur porte dans son nom l'identifiant du CA qu'il vérifie (`ca04-…`) ; les correcteurs `temoin-…` et les témoins positifs des cas sans livrable vérifient que le scénario a bien eu lieu. Les livrables d'entrée de `wf-specs-tickets` sont fabriqués par le scaffold selon le contrat de la spec 006 (sous-sections `Tnn : <titre>`, critères `CAn` propres à chaque ticket).

| Cas | Projet de départ | CA |
|---|---|---|
| `recette-ca04-specs-fieldops` | FieldOps complet, propre, sans argument : specs 001 et 002 validées, 003 en brouillon | CA1 à CA4, CA7, CA8, CA12 à CA16 (sans argument), CA20, CA21 |
| `recette-ca05-specs-tickets` | FieldOps et, commités, un livrable `docs/wf/specs-tickets.md` (T01 à T03, dont un critère interne) et une spec 004 à critère de performance | CA5, CA11, CA4, CA7, CA1, CA20, CA21 |
| `recette-ca06-depuis-le-code` | FieldOps sans `docs/specs/` (retiré par un commit), `--dirty` | CA6, CA7, CA3, CA8, CA20 (modifications non commitées) |
| `recette-ca09-ca10-relance` | FieldOps et cahier précédent commité : statuts et commentaires saisis, sources disparues, identifiant déjà retiré | CA9, CA10, CA8, CA14, CA3 |
| `recette-ca16-reference` | FieldOps, livrable `wf-specs-tickets` étiqueté `v1.3.0`, puis spec 002 et ticket T02 modifiés ; `/wf-recette v1.3.0` | CA16, CA5, CA1, CA20 |
| `recette-ca09-ca16-hors-campagne` | FieldOps, tag `v1.3.0`, puis cahier commité avec saisies dans le tableau et sous « Cas hors campagne », puis spec 001 modifiée ; `/wf-recette v1.3.0` | CA9 (saisies des cas hors campagne réintégrées ou reconduites), CA16, CA8, CA3, CA20 |
| `recette-ca17-reference-inconnue` | FieldOps et cahier précédent commité ; `/wf-recette v9.9.9` | CA17 (cas limite), CA21 |
| `recette-ca18-stack-non-couverte` | projet Python sans spec | CA18 (cas limite) |
| `recette-ca19-repertoire-vide` | répertoire vide | CA19 (cas limite) |
| `recette-ca19-sans-code-source` | FieldOps brief (documents seuls) | CA19 (cas limite) |

Tous les cas portent un correcteur `…-aucune-commande-hors-liste` : Bash ne sert qu'à `git rev-parse --short HEAD`, `git status --porcelain`, `date +%F` et, avec une référence, `git log -1 --format=%h --end-of-options <ref> --`, `git diff --name-only --end-of-options <ref> HEAD` et `git show --end-of-options <ref>:docs/wf/specs-tickets.md` (liste blanche). Les juges `llm` sont réservés à ce qu'une regex ne vérifie pas : CA14 (synthèse exacte, le juge recompte le tableau), CA11 (raisons des critères non recettables), CA10 (fonctionnalités retirées) et les messages de fin des cas sans livrable. Les motifs sont compilés et vérifiés sur des exemples par `tests/correcteurs/wf-recette.mjs`, lancé par `tests/skills/wf-recette.sh`.

Dans les cas où le scaffold dépose un cahier précédent (CA9-CA10, CA9-CA16), chaque correcteur que ce cahier satisferait de lui-même exige aussi que sa date (2026-09-15) ait disparu.

Hash rejouables des scaffolds, vérifiés dans les en-têtes : `2fc99c0` (FieldOps complet), `54ff0b9` (CA5), `dd66a1d` (CA6), `355fc68` (CA9-CA10), `19c4ec9` (CA16, HEAD), `85e1db9` (CA16, commit de `v1.3.0`) et `d9945a4` (CA9-CA16). Une modification de la fixture ou d'un scaffold les change : mettre à jour les correcteurs `ca20-entete-commit` et `ca16-reference-et-commit`.

Limite : `file_exists` ne voit que les fichiers créés pendant l'exécution. Dans les cas où un cahier précédent est commité (CA9-CA10, CA17), l'écriture est vérifiée par l'outil Write (`tool_used`) et par un témoin de date, pas par `file_exists`.
### wf-tests-manquants

Spec 012, lancée par `/wf-tests-manquants`, tous les cas `hors-reseau` (tag `wf-tests-manquants` pour ne lancer qu'eux). Chaque grader, déclaré dans `case.yaml`, porte l'identifiant du CA qu'il vérifie (`ca13-…`). Tous les cas qui produisent un livrable portent `ca07-aucun-lanceur-…` et `ca01-aucune-ecriture-hors-livrable` : aucune commande Bash ne lance `npm`, `npx`, `node`, `vitest`, `jest`, `flutter`, `dart`, `python`, `pip`… ni l'option `--coverage`.

| Cas | Projet de départ | CA |
|---|---|---|
| `tests-manquants-ca23-fieldops-monorepo` | FieldOps complet (web et Flutter), propre, sans rapport de couverture | CA1 à CA4, CA6 à CA15, CA21, CA23 |
| `tests-manquants-ca05-rapports-couverture` | FieldOps complet, `integration_test` déclaré, `coverage/coverage-summary.json` et `mobile/coverage/lcov.info` datés du 2026-09-15, antérieurs au dernier commit | CA5, CA4, CA7 |
| `tests-manquants-ca05-rapport-recent` | FieldOps complet, `coverage/coverage-summary.json` produit au lancement, postérieur au dernier commit | CA5 |
| `tests-manquants-ca16-ca18-sans-framework-ni-depot` | projet TypeScript (Vite) sans framework ni fichier de test, hors git | CA16, CA18 (cas limites), CA12 |
| `tests-manquants-ca17-tout-couvert` | module TypeScript dont chaque branche est testée (Vitest) | CA17 (cas limite) |
| `tests-manquants-ca19-stack-mixte` | FieldOps complet et un service Python (`relay/`) | CA19 (cas limite) |
| `tests-manquants-ca20-relance` | FieldOps complet, livrable précédent (M1, M3, M2 ; dernier identifiant M4) et test de M2 écrit depuis | CA20 (cas limite) |
| `tests-manquants-ca22-repertoire-vide` | répertoire vide | CA22 (cas limite) |
| `tests-manquants-ca22-sans-code-source` | FieldOps brief (documents seuls) | CA22 (cas limite) |
| `tests-manquants-ca24-projet-volumineux` | FieldOps et `src/legacy/` (2 000 modules générés) | CA24 (cas limite) |

Points chauds indépendants de la date (CA9, CA11) : le scaffold de `tests-manquants-ca23-fieldops-monorepo` ajoute des commits datés relativement au jour d'exécution (4 sur `src/api/routes/interventions.ts`, 2 sur `mobile/lib/screens/intervention_list_screen.dart`, il y a 1 à 6 jours), qui les gardent dans le top 10 sur 12 mois glissants, dans cet ordre. Le HEAD de ce cas n'est donc pas figé : son en-tête est vérifié sur la forme du hash, et le hash rejouable est vérifié dans `tests-manquants-ca05-rapports-couverture` (`558fca6`).

`tests/correcteurs/wf-tests-manquants.mjs`, lancé par `tests/skills.sh`, compile les motifs de ces cas et confronte chaque commande Bash prescrite par la skill aux correcteurs Bash « max: 0 » : la liste d'extensions de l'inventaire (`(ts|tsx|…|dart|…)`) avait été prise pour un lancement de `tsx` par `ca07-aucun-lanceur-…`.

Juges `llm` remplacés sur les livrables longs du cas principal et de CA24 (22 000 à 25 000 caractères), où ils rendaient des verdicts contradictoires ou trop stricts sur des livrables conformes (CA8, CA9-CA10, CA14, CA15, CA24) : des motifs les remplacent, éprouvés sur le livrable réel de l'eval et sur ses mutations : une ligne obligatoire par entrée (« À tester » avec un nom, type, priorité, justification), identifiants uniques, noms exportés réels, au plus deux entrées hautes, un squelette par entrée haute avec un cas par comportement et sans bibliothèque de test non déclarée, priorités lues sur la seule ligne « - Priorité : », aucun code HTTP attendu absent du code, aucun montant ni date attendus, aucun décompte de « Couverture actuelle » incluant les dossiers non lus.

Le livrable de la relance (CA20) fixe une convention que la spec laisse ouverte : la ligne d'en-tête « Dernier identifiant attribué : M<n> », qui garde la trace des identifiants retirés (même principe que `wf-cadrage-besoin`).
### wf-specs-tickets

Spec 006, lancée par `/wf-specs-tickets`, tous les cas `hors-reseau` (tag `wf-specs-tickets` pour ne lancer qu'eux). Chaque grader porte l'identifiant du CA qu'il vérifie (`ca04-…`) ; un grader « témoin » vérifie que le livrable a bien été écrit ou mis à jour. Les livrables d'entrée sont fabriqués par le scaffold selon les contrats des specs 004 (cadrage) et 005 (chiffrage) ; le cadrage du cas principal (`donnees/cadrage-besoin.md`) sert aussi aux cas CA9-CA10, CA16 et CA19 (texte saisi).

| Cas | Projet de départ | CA |
|---|---|---|
| `specs-tickets-ca01-cadrage-sans-chiffrage` | FieldOps brief et cadrage (B01 à B07, questions ouvertes et répondues), sans chiffrage | CA1 à CA9, CA11, CA12, CA15, CA17, CA20 |
| `specs-tickets-ca09-ca10-avec-chiffrage` | FieldOps brief, cadrage et chiffrage (C01 à C13 ; C01 + C02 et C04 + C05 dépassent 5 jours) | CA9, CA10, CA3, CA1 |
| `specs-tickets-ca14-projet-avec-code` | FieldOps complet (git, faux secret) et cadrage de trois évolutions, `docs/wf/` ignoré par git | CA14 (module d'export PDF à créer), CA21, CA3, CA1 |
| `specs-tickets-ca16-relance` | FieldOps brief, cadrage et livrable précédent (T01, T02, T04, T05 ; T03, T06 et T02-CA2 supprimés) | CA16 (cas limite) |
| `specs-tickets-ca13-cycle` | FieldOps brief et cadrage dont les contraintes imposent un ordre circulaire | CA13 (cas limite) |
| `specs-tickets-ca18-sans-cadrage` | FieldOps brief sans `docs/wf/` | CA18 (cas limite) |
| `specs-tickets-ca19-texte-saisi` | FieldOps brief et cadrage, texte saisi dans la commande | CA19 (cas limite) |
| `specs-tickets-ca19-aucun-besoin` | FieldOps brief et fichier d'organisation sans besoin, passé en argument | CA19 (cas limite) |
| `specs-tickets-ca22-fichier-argument` | FieldOps brief et cahier des charges dans `besoins/`, avec e-mails, téléphones et noms, passé en argument | CA22 (cas limite), CA3, CA1 |
| `specs-tickets-ca03-modifications-non-commitees` | FieldOps complet `--dirty`, cadrage du cas CA14 | CA3 (mention « modifications non commitées ») |

Hash de commit attendu : `2fc99c0` (FieldOps complet, cas CA14 et CA3) ; le cadrage déposé porte un commit antérieur (`921f57c`), pour que le hash attendu ne puisse pas être recopié. CA14 : les chemins existants sont listés dans le grader `ca14-chemins-existants-ou-a-creer` ; une modification de la fixture impose de le mettre à jour, ainsi que les hash. CA16 : le livrable précédent est déposé par le scaffold, puis réécrit ; `file_exists` ne voyant que les fichiers créés pendant l'exécution, sa présence et sa réécriture sont vérifiées par une regex `contains` sur la date de l'en-tête (`ca16-livrable-present-et-redate`). Le cas principal accorde Edit, WebFetch et WebSearch pour que ses graders « max: 0 » sur ces outils mesurent quelque chose. Les motifs des correcteurs sont vérifiés par `tests/correcteurs/wf-specs-tickets.mjs`, lancé par `tests/skills.sh`.
### wf-compte-rendu

Spec 007, lancée par `/wf-compte-rendu`, tous les cas `hors-reseau` (tag `wf-compte-rendu` pour ne lancer qu'eux). Chaque grader porte dans son nom l'identifiant du CA qu'il vérifie (`ca07-…`) ; un grader « témoin » prouve que le scénario a eu lieu là où les vérifications d'absence réussiraient sans rien prouver. Les notes propres à un cas (fictives) sont dans son dossier `donnees/`.

| Cas | Projet de départ | CA |
|---|---|---|
| `compte-rendu-ca01-point-hebdo` | FieldOps brief, notes `notes/2026-10-07-point-hebdo.md` de la fixture | CA1, CA3 à CA12, CA19, CA20 |
| `compte-rendu-ca03-ca04-index-existant` | FieldOps complet (code, git, faux secret), deux comptes rendus et leur index, notes hors du projet sans date dans le nom | CA1, CA3 (nom exact), CA4 (ordre de l'index), CA6, CA10, ADR-001 (fichier d'environnement) |
| `compte-rendu-ca02-sans-argument` | FieldOps brief, aucun argument | CA2 (question posée, rien écrit) |
| `compte-rendu-ca02-notes-collees` | FieldOps brief, texte des notes dans la commande | CA2 (« notes fournies dans la conversation »), CA4, CA5, CA7, CA9, CA11 |
| `compte-rendu-ca13-transcription-vtt` | FieldOps brief, transcription `notes/2026-09-30-atelier.vtt` de la fixture | CA13, CA3 (objet tiré du nom de fichier), CA8, CA9, CA11 |
| `compte-rendu-ca13-ca14-transcription-anglaise` | FieldOps brief, transcription anglaise horodatée `[hh:mm:ss]` en `.txt` | CA13, CA14, CA5, CA7, CA8 |
| `compte-rendu-ca15-sans-date` | FieldOps brief, notes sans date, nom sans date | CA15 (question posée, rien écrit) |
| `compte-rendu-ca16-relance` | FieldOps brief, compte rendu existant tiré des mêmes notes, notes complétées | CA16 |
| `compte-rendu-ca17-autre-reunion-meme-nom` | FieldOps brief, compte rendu du même nom tiré d'autres notes | CA17 (question posée, rien écrit) |
| `compte-rendu-ca17-nouvelle-reunion` | même départ, réponse « nouvelle réunion » donnée après le chemin | CA17 (suffixe `-2`, premier compte rendu intact), CA4 |
| `compte-rendu-ca18-chemin-inexistant`, `compte-rendu-ca18-fichier-vide`, `compte-rendu-ca18-format-docx` | FieldOps brief | CA18 |

Valeur déterministe : commit `2fc99c0` dans `compte-rendu-ca03-ca04-index-existant` (les comptes rendus déposés sont exclus par `.git/info/exclude`, l'arbre reste propre ; ils portent un hash factice, `a1b2c3d`, que le nouveau compte rendu ne doit pas reprendre).

Tous les cas accordent `Edit` : les correcteurs `tool_used: Edit` à `max: 0` mesurent ainsi un refus réel. Les interdictions de lecture couvrent Read, Bash (motif sur la commande) et Glob. `tests/correcteurs/wf-compte-rendu.mjs`, lancé par `tests/skills/wf-compte-rendu.sh`, compile tous les motifs, les essaie sur des exemples positifs et négatifs, vérifie que les commandes prescrites par la skill ne déclenchent aucune interdiction, et que la commande du nom de fichier donne les noms attendus.

Limite : une eval n'a qu'un tour. Pour CA2 (sans argument), CA15 et CA17, on vérifie que la question est posée et que rien n'est écrit. La suite de CA17 est couverte en donnant la réponse d'avance après le chemin (`/wf-compte-rendu <notes> nouvelle réunion`, comportement de la skill à ajouter à la spec) ; la reprise après une réponse dans un second message (texte collé de CA2, date de CA15) n'est pas couverte par les evals. Les notes collées sont couvertes par un texte fourni directement après la commande (amendement 1 de l'ADR-001).

### wf-montee-version

Spec 013, lancée par `/wf-montee-version [argument]` (tags `wf-montee-version` et `spec-013`). Chaque correcteur porte dans son nom le critère qu'il vérifie (`ca14-…`) ; les motifs sont compilés et vérifiés sur des exemples positifs et négatifs, et sur des livrables d'exemple, par `tests/correcteurs/wf-montee-version.mjs` (lancé par `tests/skills.sh`).

| Cas | Projet de départ | Tag | CA |
|---|---|---|---|
| `montee-version-ca10-fieldops-sans-argument` | FieldOps complet, faux secret, `docs/wf/revue-securite.md` commité (S3 : express 4.18.2, corrigé en 4.19.2) | `reseau` | CA1 à CA6, CA10 à CA16, CA20, CA21, CA25, CA27 (une sous-section par application) |
| `montee-version-ca07-registre-injoignable` | FieldOps complet, réseau coupé, `.npmrc` vers un registre injoignable | `hors-reseau` | CA7, CA4 à CA6 (repli), CA11 (livrable de sécurité absent), CA12 (non vérifiée), CA16, CA20, CA25 |
| `montee-version-ca08-cible-react-dom` | FieldOps complet, argument `react-dom 19` | `reseau` | CA8, CA9 (version partielle résolue), CA12 à CA15, CA24 |
| `montee-version-ca09-paquet-absent` | FieldOps complet, argument `lodash 4` | `reseau` | CA9 (paquet absent, aucun livrable) |
| `montee-version-ca09-version-inexistante` | FieldOps complet, argument `react 99.0.0` | `reseau` | CA9 (version inexistante, aucun livrable) |
| `montee-version-ca18-cible-deja-atteinte` | FieldOps complet, argument `express 4.18.2` | `reseau` | CA18, CA8, CA24 |
| `montee-version-ca19-ca22-projet-mixte-sans-lockfile` | projet fictif hors git : JS/TS sans lockfile ni script, PHP (`composer.json`) | `reseau` | CA19, CA17, CA22, CA13 (`_.pluck`, deux occurrences) |
| `montee-version-ca27-monorepo-pnpm` | monorepo pnpm fictif, react 17.0.2 (`apps/web`) et 18.2.0 (`apps/admin`), `.node-version` | `reseau` | CA27, CA3, CA4, CA15 (pnpm), CA16 |
| `montee-version-ca23-relance` | FieldOps et ancien livrable commité, périmé (react 16.14.0) | `hors-reseau` | CA23 |
| `montee-version-ca26-sans-manifeste` | FieldOps brief (documents seuls) | `hors-reseau` | CA26 |

Tous les cas portent `ca20-ni-installation-ni-execution`, `ca20-ni-branche-ni-commit`, `ca01-aucune-modification-par-bash` et `ca01-curl-sans-ecriture` (motifs repris de `evals/analyse-projet/`).

Réseau : la passe `reseau` autorise `registry.npmjs.org`, `pub.dev`, `endoflife.date` et `storage.googleapis.com` (versions publiées de Flutter), mais aucun domaine de documentation : les notes de version hors pub.dev y sont injoignables. Les correcteurs acceptent donc « non vérifiée » pour les ruptures, et « non déterminé » pour la dernière LTS, la dernière stable et la fin de support si ces sources ne répondent pas, et `ca12-sources-effectivement-consultees` vérifie qu'aucune URL n'est donnée comme source sans avoir été consultée. Les valeurs publiques ne sont jamais figées : dernière version « 18 ou plus » pour react, date de fin de support de Node.js 18 (2025-04-30) acceptée seulement si endoflife.date a répondu.

Hash attendus dans les en-têtes, rejouables : `18776c7` (FieldOps et livrable de sécurité), `2fc99c0` (FieldOps seul), `822183b` (monorepo pnpm), `7863f6e` (relance). Une modification de la fixture ou d'un scaffold les change : mettre à jour les correcteurs `adr001-en-tete-…`, `ca24-argument-en-tete` et `ca23-en-tete-commit-actualise`.

Limites : CA28 (impacts partiels d'un projet volumineux) et les variantes `.fvm/fvm_config.json` (CA5), yarn (CA15) et pub sans lockfile (CA19) ne sont vérifiés que par les tests structurels. `file_exists` ne voyant que les fichiers créés pendant l'exécution, la relance (CA23) est vérifiée par la réécriture observée (`Write`) et le contenu du livrable.

### wf-audit-web

Spec 011, lancée par `/wf-audit-web [URL]`, tous les cas `hors-reseau` (tag `wf-audit-web` pour ne lancer qu'eux). Chaque grader porte l'identifiant du CA qu'il vérifie (`ca06-…`) ; les correcteurs `…-temoin-…` vérifient que le scénario a bien été mis en place. Les motifs des correcteurs sont vérifiés sans modèle par `tests/correcteurs/wf-audit-web.mjs` (lancé par `tests/skills.sh`), y compris contre les commandes Bash prescrites par la skill.

Aucun correcteur regex sur le livrable ne passe sans livrable écrit : un motif « absent » y est écrit comme un motif « présent » qui exige aussi l'en-tête `wf-audit-web` ; dans `audit-web-ca24-relance`, chaque motif exige en plus l'absence de la date de l'audit déposé par le scaffold (2026-09-15), pour que l'ancien livrable ne satisfasse aucun correcteur à lui seul. La route des constats de titre (CA9) est vérifiée par motif, pas par un juge : le juge refusait « toutes les routes » pour une application monopage servie par un seul document.

| Cas | Projet de départ | CA |
|---|---|---|
| `audit-web-fieldops` | FieldOps complet (web et Flutter), propre, faux secret, image de 259 523 octets ajoutée dans `public/img/` | CA1 à CA13, CA21, CA25, CA28, hors-périmètre sécurité |
| `audit-web-ca23-plusieurs-fronts` | FieldOps web seul, portail Next.js (`portail/`) et gabarits PHP (`legacy-php/`) | CA23, CA22, CA6 (`<Image>`), CA7 (`<textarea>`, faux positifs), CA9 (titre sans meta description) |
| `audit-web-ca24-relance` | FieldOps web seul, audit précédent commité (W1 à W4, dernier identifiant W6), puis W2 corrigé | CA24 |
| `audit-web-ca17-ca19-url-sans-lighthouse` | FieldOps web seul, URL `https://fieldops.example.invalid/interventions` en argument | CA17, CA19, CA3 et CA11 en mode URL |
| `audit-web-ca20-api-seule` | API Express seule, hors git | CA20 (aucun livrable) |
| `audit-web-ca20-flutter-seule` | application Flutter de FieldOps seule, hors git | CA20 (aucun livrable) |
| `audit-web-ca26-sans-code-source` | FieldOps brief (documents seuls) | CA26 (aucun livrable) |
| `audit-web-ca26-repertoire-vide` | répertoire vide | CA26 (aucun livrable) |
| `audit-web-ca27-projet-volumineux` | FieldOps web seul et 2 000 composants générés sous `src/web/legacy/` | CA27 |
| `audit-web-url-hostile` | FieldOps web seul, argument `https://x.invalid/'$(touch pwned)'` | argument écarté sans appel au shell (aucun fichier `pwned`, aucune commande avec la substitution), audit du code seul (à ajouter à la spec) |

Hash de commit attendus dans les en-têtes, rejouables : `d2e6acb` (`audit-web-fieldops`), `2246bd5` (`audit-web-ca23-plusieurs-fronts`), `2bf08f8` (`audit-web-ca24-relance`), `be04389` (URL). Une modification de la fixture les change : mettre à jour les graders `adr001-en-tete`.

Mode URL : le réseau n'est pas simulable et Lighthouse n'est installé ni sur les postes ni sur les runners de la CI. Le cas URL exerce donc le chemin « Lighthouse absent » (CA17) ; son témoin `ca17-temoin-lighthouse-absent` échoue si Lighthouse est trouvé, auquel cas le cas exercerait CA16 (URL `.invalid` injoignable) et ses correcteurs CA17 ne prouveraient rien. CA14, CA15, CA16 et CA18 (scores, version, profil, heure, problèmes rattachés ou non au code, page injoignable, redirection) ne sont pas couverts par une eval : la lecture du rapport Lighthouse par `skills/wf-audit-web/scripts/lighthouse-summary.mjs` est testée par `tests/skills/wf-audit-web.sh` sur des rapports synthétiques (y compris mal formés ou hostiles), la commande Lighthouse prescrite y est exécutée avec un faux `lighthouse` et des URL piégées, sous bash et zsh, et la rédaction du livrable à partir de ce résumé reste à vérifier à la main, sur un poste avec Lighthouse : `claude --plugin-dir .` puis `/wf-audit-web <URL d'un site public>` dans un projet web, en contrôlant les scores, la version, le profil mobile, l'heure, les URL demandée et auditée, puis avec une URL redirigée et une URL injoignable.

### wf-release-notes

Spec 009, lancée par `/wf-release-notes`, tous les cas `hors-reseau` (tag `wf-release-notes` pour ne lancer qu'eux). Chaque grader, déclaré dans `case.yaml`, porte l'identifiant du CA qu'il vérifie (`ca04-…`). Les variantes de l'historique propres à un cas (commits, tags, clone superficiel) sont construites dans son `scaffold.sh`, après `tests/fixtures/build-fieldops.sh`.

| Cas | Projet de départ | CA |
|---|---|---|
| `release-notes-ca04-ca16-plage-par-defaut` | FieldOps `--dirty`, plus un changement cassant sans action décrite et un fichier d'environnement versionné ; sans argument | CA1 à CA4, CA6 (manifeste), CA8, CA10 (non applicable), CA11, CA12, CA16, CA24 à CA26 |
| `release-notes-ca05-ca08-plage-entre-tags` | FieldOps, `v1.1.0 v1.2.0` | CA1 à CA3 (borne haute), CA5, CA6, CA8, CA11, CA12, CA25 |
| `release-notes-ca09-ca15-ca16-version-en-argument` | FieldOps, `v1.0.0 v1.1.0 --version 1.1.0` : revert, cassant avec action, hors convention, fusion, ticket | CA3, CA5, CA6 (argument), CA8, CA9, CA11, CA12, CA15, CA16 |
| `release-notes-ca13-ca14-branche-non-fusionnee` | FieldOps, `v1.2.0 feat/export-pdf --version 1.3.0` | CA2 (sous-section omise), CA3, CA5, CA6, CA13, CA14 |
| `release-notes-ca17-relance-meme-version` | FieldOps et livrable commité (1.2.0 périmée, 1.1.0 retouchée, 1.0.0), `v1.1.0 v1.2.0` | CA17 |
| `release-notes-ca10-ca18-nouvelle-version-en-tete` | FieldOps et livrable commité (1.1.0 retouchée, 1.0.0), sans argument | CA10, CA18, CA2, CA12 |
| `release-notes-ca07-ca19-flutter-sans-tag` | application Flutter seule à la racine (`pubspec.yaml` en `3.6.0+117`), tags supprimés | CA7, CA19, CA6, CA12, CA15 |
| `release-notes-ca23-clone-superficiel` | clone de profondeur 3, `package.json` sans `version` | CA23, CA6 (version non déterminée) |
| `release-notes-ca20-plage-vide` | FieldOps, tag `v1.3.0` sur `HEAD` | CA20 |
| `release-notes-ca21-reference-inexistante` | FieldOps, `v0.9.0 v1.2.0` | CA21 |
| `release-notes-ca21-reference-piegee` | FieldOps, référence avec apostrophe et substitution de commande (`v1.0.0'$(touch pwned)'`) | CA21, injection shell : refus sans aucune commande, aucun fichier `pwned` |
| `release-notes-ca22-hors-git` | copie de FieldOps sans historique | CA22 |

Hash rejouables vérifiés : en-têtes `28e190e`, `db46741`, `17691e6`, `4a5b78b`, `fe0d161`, `5366555`, `9986263` (borne haute de chaque cas), et les commits de chaque plage dans « Références ». Une modification de la fixture ou d'un scaffold les change : mettre à jour les graders `ca03-…`, `ca04-…`, `ca05-…`, `ca12-…`.

Les graders de « Références » supposent le format prescrit par la skill : une ligne par entrée avec tous ses hash, une ligne par commit sans entrée, aucun autre hash sur la ligne. Les graders `ca17-…` et `ca18-…` comparent les sections existantes au texte exact de `donnees/release-notes-precedent.md`, jusqu'à la fin du fichier (identité octet pour octet, au saut de ligne final près).

Le correcteur générique d'écriture Bash, repris de wf-doc-projet, détecte `git tag <nom>`, `git tag -a|-s|-d|-f` et `git branch <nom>` (corrigé dans les cas doc-projet : son motif exigeait un séparateur juste après `tag` ou `branch`). Le correcteur dédié `…-aucun-tag-ni-publication` couvre en plus `git push` et la publication d'une release.

### wf-passation

Spec 016, lancée par `/wf-passation`, tous les cas `hors-reseau` (tag `wf-passation`). Chaque grader porte l'identifiant du CA qu'il vérifie (`ca08-…`).

Tous les cas portent `ca01-commandes-autorisees` : Bash ne sert qu'aux commandes en lecture de la skill (`git rev-parse --short HEAD`, `git status --porcelain`, `date +%F`, `git symbolic-ref refs/remotes/origin/HEAD`, `git show-ref --verify refs/heads/main|master`, `git branch -a --no-merged=…`, `git rev-list --count --end-of-options …`, `git log -1 --format=%cs --end-of-options …`, aucun argument commençant par `-`), ce qui exclut aussi toute récupération distante (`git fetch`, hors périmètre) et toute option injectée par un nom de référence.

| Cas | Projet de départ | CA |
|---|---|---|
| `passation-fieldops` | FieldOps complet (web et Flutter), propre, faux secret, aucun livrable `wf-*` | CA1 à CA5, CA7 à CA10, CA12 à CA14, CA16, CA17, CA20 (monorepo), CA21, CA23 |
| `passation-ca03-ca04-livrables-wf` | FieldOps `--dirty` et livrables commités : doc-projet en dossier, onboarding, exploitation (contrat de la spec 018), analyse-projet, chiffrage, revue-securite | CA3, CA4 (format dossier), CA13 (rien des livrables internes), CA21, CA1 |
| `passation-ca15-relance` | FieldOps, doc-projet en fichier unique et dossier de passation précédent avec saisies à la main | CA15, CA4 (fichier unique), CA14, CA16 |
| `passation-ca10-branches-distantes` | FieldOps `--dirty`, `origin/HEAD`, branche distante non fusionnée, branche locale fusionnée | CA10, CA14, CA17, CA21 |
| `passation-ca11-branche-principale-inconnue` | FieldOps dont `main` est renommée `trunk` | CA11 (cas limite) |
| `passation-ca06-ca18-hors-git-sans-deploiement` | copie de FieldOps hors git, sans workflow, `Dockerfile` ni `docker-compose.yml` | CA6, CA18 (cas limites), CA8 |
| `passation-ca19-stack-non-couverte` | projet Python fictif déployé par `flyctl`, Stripe par `.env.example`, Sentry par `requirements.txt` seul, IP en dur | CA19 (cas limite), CA5, CA7, CA8, CA23 |
| `passation-ca22-repertoire-vide`, `passation-ca22-sans-code-source` | répertoire vide ; FieldOps brief (documents seuls) | CA22 (cas limite) |

Hash de commit attendus dans les en-têtes (scaffolds rejouables) : `2fc99c0` (FieldOps, y compris `ca10` et `ca11`, dont les références ajoutées ne déplacent pas `HEAD`), `8de0c62` (`ca03-ca04`), `a2ef90b` (`ca15`). Une modification de la fixture ou de ces scaffolds les change : mettre à jour les graders `ca21-entete-commit`, `ca16-commit-de-reference` et `ca15-commit-mis-a-jour`.

CA10 : aucune branche distante ne peut être récupérée en eval ; le scaffold crée donc les références distantes à la main (`git update-ref`, `git symbolic-ref`), avec des commits construits par `git commit-tree` sans toucher à l'arbre de travail.

CA23 : les adresses en dur de FieldOps sont celles du registre d'images et du webhook de `.github/workflows/deploy.yml` (lignes 29 à 33 et 44 à 48) ; `localhost`, le service `db` de `docker-compose.yml`, `.env.example` et les README sont exclus. Le cas Python ajoute une adresse IP de la plage de documentation (`203.0.113.42`) et une adresse d'écoute `0.0.0.0`, exclue comme adresse locale. Les exclusions sont vérifiées par regex, ligne par ligne (`ca23-exclusions-non-signalees`) : le juge `llm` qui les vérifiait était bruité sur ce long livrable.

Juges `llm` : le livrable de `passation-fieldops` dépasse 10 Ko et les juges y ont donné des faux rouges répétés (séries r8, r14, r17, sur des livrables conformes). Tous ses critères sont donc vérifiés par regex, sauf `ca16-synthese-coherente`, seul juge restant : comparer les nombres annoncés par la Synthèse au nombre de lignes du tableau de la checklist demande un comptage qu'une regex ne fait pas.

CA5 et CA8 : `.github/workflows/purge.yml` (tâche planifiée, spec 018) n'est pas une procédure de déploiement, mais son secret `PRODUCTION_DATABASE_URL` est à transmettre ; `MAP_API_KEY_EXPIRES_AT` (`.env.example`) est une date d'expiration, pas un secret.

CA15 : le dossier déposé suit un format antérieur (statut en colonne du milieu, « Titulaire : »…), pour que les correcteurs de conservation n'y réussissent pas sans relance.

`tests/correcteurs/wf-passation.mjs`, lancé par `tests/skills/wf-passation.sh`, compile tous les motifs des cas `passation-*`, vérifie la liste blanche Bash sur des commandes autorisées et interdites, les correcteurs de `passation-fieldops` sur un livrable conforme et des livrables fautifs, et l'échec des correcteurs de conservation de CA15 sur le dossier déposé.

### wf-rapport-avancement

Spec 008, lancée par `/wf-rapport-avancement [début fin]`, tous les cas `hors-reseau` (tag `wf-rapport-avancement` pour ne lancer qu'eux). Chaque grader, déclaré dans `case.yaml`, porte l'identifiant du CA qu'il vérifie (`ca09-…`). Les cas qui lisent l'historique vérifient aussi que Bash ne sert qu'aux commandes prescrites par la skill : quelques commandes git en lecture et `date +%F` recopiées telles quelles, et des blocs dont les valeurs (dates, branches, hash, tickets) passent par un heredoc à délimiteur entre apostrophes (`WF_VALEURS_3b9e`), sans substitution de commande ni redirection, avec `--end-of-options` dans chaque `git log` et `git show`.

| Cas | Projet de départ | CA |
|---|---|---|
| `rapport-avancement-ca04-periode-en-argument` | FieldOps complet, `docs/wf/specs-tickets.md` et deux comptes rendus (dans et hors période) commités ; période du 2026-01-13 au 2026-03-18, bornes sur deux commits | CA1 à CA4, CA6 (repli sur `main`), CA7 à CA9, CA10 (aucune branche dans la période), CA11, CA13 à CA17 |
| `rapport-avancement-ca10-branche-en-cours` | FieldOps complet sans livrable `wf-` ; branche non fusionnée dans la période et une autre hors période, fichier d'environnement de recette versionné, commits « maj » (diff lisible) et « wip » (diff binaire) | CA8 à CA10, CA12, CA13 (sans compte rendu), CA18, CA24 |
| `rapport-avancement-ca05-ca20-relance` | rapport précédent commité (période jusqu'au 2026-09-25), lancé sans argument | CA5, CA20, CA3 |
| `rapport-avancement-ca05-sans-periode` | FieldOps complet, ni rapport précédent ni argument | CA5 (cas limite) |
| `rapport-avancement-ca06-origin-head` | clone dont `origin/HEAD` désigne `principale`, branche locale `main` restée sur v1.0.0 | CA6, CA10 (branche distante) |
| `rapport-avancement-ca06-branche-introuvable` | branche principale renommée `develop` | CA6 (cas limite) |
| `rapport-avancement-ca19-ca06-sans-commit-master` | branche principale renommée `master`, période sans aucun commit | CA19, CA6 (repli sur `master`) |
| `rapport-avancement-ca23-clone-superficiel` | clone superficiel (3 commits, à partir du 2026-09-22), période à partir du 2026-09-01 | CA23 |
| `rapport-avancement-ca22-hors-git` | copie de FieldOps sans historique | CA22 |
| `rapport-avancement-ca21-periode-inversee` | date de fin antérieure à la date de début | CA21 (cas limite) |
| `rapport-avancement-ca21-date-future` | date de début postérieure à la date du jour (2099) | CA21 (cas limite) |
| `rapport-avancement-ca21-date-mal-formee` | date de début absente du calendrier (30 février) | CA21 (cas limite) |
| `rapport-avancement-ca04-fuseaux-branches-piegees` | quatre commits aux bornes dans des fuseaux décalés (seule la date de commit `%cs` compte) ; deux branches non fusionnées aux noms piégés (apostrophe et substitution de commande ; `--output=…`, créée par `update-ref`) | CA4 (bornes), sécurité : aucun nom piégé inséré dans une commande, aucun fichier créé, branches signalées dans « Points non déterminés » |

Les hash attendus sont ceux des scaffolds, rejouables : `2d9eb2a` (HEAD du cas principal), `4e7a5d4` (branche en cours), `21a6d55` (relance), et ceux de la fixture FieldOps (HEAD de `main` : `2fc99c0`). Les dates de la période sont comparées à la date de commit en UTC (fixture) ; la date du jour n'est jamais figée, seulement bornée (postérieure à 2026-10).

Limites : l'eval ne joue qu'un tour, sans réponse de l'utilisateur. Les reprises de ce qu'il fournit (prochaines étapes, décisions attendues, points de vigilance « réponse de l'utilisateur », CA12 à CA14) ne sont donc pas jouées : seule la question finale l'est (`ca12-ca13-questions-posees`).

### wf-publication-store

Spec 015, lancée par `/wf-publication-store`, tous les cas `hors-reseau` sauf `publication-store-ca15-documentation-lue` (tag `wf-publication-store` pour ne lancer qu'eux). Chaque grader, déclaré dans `case.yaml`, porte l'identifiant du CA qu'il vérifie (`ca10-…`). Les cas qui produisent un livrable portent `…-bash-liste-blanche` : Bash ne sert qu'à `git rev-parse --short HEAD`, `git status --porcelain`, `git ls-files -- '*key.properties' '*.jks' '*.keystore' '*.p12' '*.p8'` et `date +%F`.

| Cas | Projet de départ | CA |
|---|---|---|
| `publication-store-ca03-fieldops` | FieldOps complet (web à la racine, Flutter dans `mobile/`), propre, faux secret, sans métadonnées ni notes de version | CA1 à CA3, CA6 à CA11, CA15 à CA18, CA21 à CA23, CA26, CA27 |
| `publication-store-ca04-react-native` | application React Native (`ios/`, `android/`), sans Flutter | CA4 |
| `publication-store-ca04-expo` | application Expo en flux géré (ni `ios/` ni `android/`) | CA4 |
| `publication-store-ca04-natif-kotlin` | application Android native (Kotlin, Gradle Kotlin DSL) | CA4 |
| `publication-store-ca04-natif-swift` | application iOS native (Swift, projet Xcode) | CA4 |
| `publication-store-ca05-sans-mobile` | FieldOps web seul (`build-fieldops-web.sh`) | CA5 |
| `publication-store-ca12-ca13-ca14-signature` | FieldOps et un commit : fichiers de clés suivis par git, fichiers Firebase, mots de passe de signature en clair, notes de version 1.2.0 sans « Nouveautés » | CA12 à CA14, CA19 (Nouveautés absente), CA20 (versions égales) |
| `publication-store-ca18-ca19-ca20-ca22-fastlane` | FieldOps et un commit : métadonnées fastlane en français (description courte Android de 126 caractères), notes de version 1.3.0 pour une application en 1.2.0 | CA1, CA18 à CA20, CA22 |
| `publication-store-ca24-ca25-deux-applications` | hors git, deux applications Flutter : `apps/technicien` (iOS et Android) et `apps/superviseur` (Android seul) | CA6, CA24 à CA26 |
| `publication-store-ca15-documentation-lue` (`reseau`) | FieldOps complet, documentation des stores joignable | CA15 (page lue, date de consultation) |
| `publication-store-ca26-mise-a-jour` | FieldOps `--dirty` et livrable précédent commité, périmé (1.1.0, build 9) | CA26 |

Valeurs déterministes vérifiées : commit `2fc99c0` (FieldOps complet, CA26), ligne 31 du `build.gradle` réécrit par le scaffold du cas signature (`storePassword` en clair, CA14). Les marqueurs `FIELDOPS_FAUX_KEYPROP_5b17`, `FIELDOPS_FAUX_JKS_4d8e` et `FIELDOPS_FAUX_P8_2c6a` sont dans des fichiers de clés qui ne doivent jamais être ouverts : leur absence de la trace prouve CA12. Les fichiers Firebase (`google-services.json`, `GoogleService-Info.plist`, marqueur `FIELDOPS_FAUX_FIREBASE_8e03`) et FlutterFire (`lib/firebase_options.dart`, marqueur `FIELDOPS_FAUX_FLUTTERFIRE_3a9d`) ne sont jamais ouverts non plus (choix plus prudent que CA12) : leurs marqueurs sont vérifiés absents de la trace et du livrable. `FIELDOPS_FAUX_MDP_91c2` est dans `build.gradle`, que l'outil lit : son absence est vérifiée dans le livrable seulement.

Réseau : la passe `hors-reseau` n'accorde pas WebFetch, la documentation des stores est donc injoignable et les cas vérifient le repli de CA16 (statut « à vérifier », valeur relevée, lien officiel, aucune exigence affirmée). La seconde moitié de CA15 (page lue : exigence citée avec sa date de consultation) est couverte par `publication-store-ca15-documentation-lue`, tagué `reseau` : ce cas exige que la passe `reseau` accorde en plus `WebFetch(domain:developer.android.com)` et `WebFetch(domain:developer.apple.com)` (commande ci-dessus et `.github/workflows/evals.yml`). Ses correcteurs ne figent aucune exigence publique (ADR-001) : ils vérifient le statut « à vérifier », le lien officiel et la mention « consulté le AAAA-MM-JJ ».

### wf-exploitation

Spec 018, lancée par `/wf-exploitation`, tous les cas `hors-reseau` (tag `wf-exploitation` pour ne lancer qu'eux). Chaque grader, déclaré dans `case.yaml`, porte l'identifiant du CA qu'il vérifie (`ca09-…`). Tous les cas portent `ca20-aucune-commande-executee` : Bash ne sert qu'à `git rev-parse --short HEAD`, `git status --porcelain` et `date +%F` (liste blanche).

| Cas | Projet de départ | CA |
|---|---|---|
| `exploitation-ca01-fieldops` | FieldOps complet (web et Flutter), propre, faux secret, sans doc-projet | CA1 à CA6, CA8 à CA10, CA12 à CA25 |
| `exploitation-ca03-doc-projet-fichier` | FieldOps et livrable doc-projet en fichier unique, commité | CA3 |
| `exploitation-ca03-ca27-relance-doc-projet-dossier` | FieldOps, livrable doc-projet en dossier et ancien guide (2026-01-15), commités | CA3, CA27 |
| `exploitation-ca05-ca07-ca11-projet-minimal` | projet TypeScript avec `pino-http`, sans tâche planifiée ni mode de lancement | CA5, CA7, CA8, CA11, CA16, CA19 |
| `exploitation-ca25-flutter-seul` | application Flutter seule avec Sentry et messages d'erreur affichés | CA25, CA7, CA21, CA22 |
| `exploitation-ca26-stack-non-couverte` | projet Python avec `Dockerfile`, `docker-compose.yml` (`restart`), CI programmée, `.env.example` | CA26, CA4, CA6, CA8, CA9 |
| `exploitation-ca28-repertoire-vide` | répertoire vide | CA28 (cas limite) |
| `exploitation-ca28-sans-code-source` | FieldOps brief (documents seuls) | CA28 (cas limite) |

Le hash attendu dans l'en-tête de `exploitation-ca01-fieldops` est celui de la fixture, rejouable : `2fc99c0`. Une modification de la fixture le change : mettre à jour `ca02-en-tete-commit`.

### wf-chiffrage

Spec 005, lancée par `/wf-chiffrage`, tous les cas `hors-reseau` (tags `wf-chiffrage` et `spec-005` pour ne lancer qu'eux). Chaque grader porte l'identifiant du CA qu'il vérifie (`ca04-…`) ; un grader « témoin » vérifie que le livrable a bien été écrit ou mis à jour, sans quoi les vérifications d'absence réussiraient sans rien prouver. L'entrée par défaut, `docs/wf/cadrage-besoin.md`, est fabriquée par le scaffold selon le contrat de la spec 004 (dossier `donnees/` de chaque cas).

| Cas | Projet de départ | CA |
|---|---|---|
| `chiffrage-ca01-cadrage-fieldops-brief` | FieldOps brief (ni code ni git) et cadrage B01 à B07 : un besoin trop imprécis (B07), questions ouvertes et répondues, budget en euros dans une réponse | CA1 à CA14, CA22 |
| `chiffrage-ca15-ca16-projet-avec-code` | FieldOps complet (git propre, faux secret), cadrage de trois évolutions du back-office et livrable `wf-analyse-projet` à deux risques élevés, dont un sans rapport avec les évolutions ; les entrées portent un commit plus ancien (`921f57c`), qui ne doit pas être recopié | CA15, CA16, CA17, CA23 (dont Grep toujours avec `glob`), CA3 (commit `2fc99c0`), CA1, CA6, CA14 |
| `chiffrage-ca03-modifications-non-commitees` | FieldOps complet `--dirty`, sans faux secret, cadrage d'une seule évolution | CA3 (mention « modifications non commitées ») |
| `chiffrage-ca18-relance` | FieldOps brief, cadrage mis à jour (B03 retiré, B05 modifié, B06 ajouté) et chiffrage précédent (C01 à C09, dernier identifiant attribué C10) | CA18 (cas limite), CA3 |
| `chiffrage-ca19-sans-cadrage` | FieldOps brief sans cadrage, sans argument | CA19 (cas limite) |
| `chiffrage-ca20-texte-saisi` | FieldOps brief avec cadrage, texte saisi dans la commande | CA20 (cas limite) |
| `chiffrage-ca20-aucun-besoin` | FieldOps brief, ordre du jour logistique passé en argument | CA20 (cas limite) |
| `chiffrage-ca20-argument-piege` | FieldOps brief avec cadrage et `besoin.md`, argument `$(touch pwned)besoin.md` | CA20 (cas limite) ; sécurité : argument refusé sans rien exécuter, aucun fichier `pwned` |
| `chiffrage-ca21-ca24-cahier-des-charges-brut` | FieldOps brief, cahier des charges brut sans `Bnn` dans un sous-dossier, avec e-mail et téléphones | CA21, CA24 (cas limites), CA1, CA3, CA9, CA10, CA14 |

L'en-tête (CA3) est vérifié par motifs : un juge `llm` refusait un « non déterminé (le dépôt git ne contient aucun commit) » pourtant juste, `claude plugin eval` créant un dépôt vide dans le dossier parent. CA5, CA6 et CA10 sont vérifiés à la fois par des motifs sur les lignes de tableau (`| Cnn | … |`, valeurs hors pas de 0,5, estimation haute au-delà de 5 jours, tâche de lot sans `Bnn`) et par un juge `llm` ligne à ligne ; CA8 (totaux exacts) ne peut l'être que par un juge, qui refait la somme. CA7 et CA22 (cas principal) sont vérifiés par motifs, les juges étant bruités sur ce long livrable : CA7 énumère les couples d'estimations dont la haute est au moins le double de la basse (pas de 0,5, jusqu'à 5 jours) et exige dans leur commentaire un renvoi `Hn`, `Qnn` ou à un risque ; il ne juge pas la qualité de l'explication.
## Correcteurs

Moteur : `claude plugin eval` compile chaque motif avec `new RegExp` du runtime JavaScript de Claude Code (Bun, donc JavaScriptCore) : `input_match` sans drapeau, sur l'entrée de l'outil sérialisée en JSON ; `pattern` avec ses `flags`. Les regards arrière de longueur variable sont acceptés par JavaScriptCore comme par V8 (Node). La validation gratuite (`--max-cost-usd 0`) ne compile pas les motifs : un motif invalide n'apparaît qu'à la notation (« grader threw », correcteur en échec), et un `tool_used` `max: 0` sans appel de l'outil ne le compile jamais. D'où `tests/correcteurs/wf-analyse-projet.mjs`, lancé par `tests/skills.sh` : il compile les motifs des correcteurs renforcés et les vérifie sur des exemples positifs et négatifs, et sur les commandes prescrites par la skill.

Valeurs déterministes vérifiées : commit `2fc99c0` (dernier commit de `main` de la fixture), `487e618` (commit du livrable précédent, CA12), période `2026-08-26` à `2026-09-29` (CA16). Les valeurs qui dépendent du registre ou de la date d'exécution (dernière version publiée, nombre de commits sur 12 mois glissants) ne sont jamais figées.
### wf-cadrage-besoin

Spec 004, tous les cas tagués `hors-reseau`. Chaque grader porte dans son nom le critère d'acceptation vérifié (`ca04-…`) ; un grader « témoin » vérifie que le livrable a bien été écrit ou mis à jour, sans quoi les vérifications d'absence réussiraient sans rien prouver. Les données propres à un cas sont dans son dossier `donnees/`.

- `cadrage-besoin-brief-et-notes` : cas principal sur FieldOps brief (CA1 à CA6, CA8 à CA11, CA19, CA21, CA23) ;
- `cadrage-besoin-ca02-sections-vides` : brief très court, les neuf sections présentes même vides, « Aucun élément. » (CA2) ;
- `cadrage-besoin-ca04-source-pdf` : source PDF citée avec sa page (CA4, CA5, CA9) ;
- `cadrage-besoin-ca07-plateformes-absentes` : brief sans plateforme cible (CA7) ;
- `cadrage-besoin-ca12-ca14-ca15-relance-sans-argument` : relance sans argument, réponse saisie à la main, identifiants retirés, source devenue introuvable conservée dans l'en-tête (CA12, CA14, CA15) ;
- `cadrage-besoin-ca13-ca14-nouvelle-source` : relance avec un e-mail de réponse du client (CA13, CA14, CA19) ;
- `cadrage-besoin-ca14-ca15-dernier-identifiant-retire` : plus grands identifiants retirés, portés par la ligne « Derniers identifiants attribués » ; source déjà introuvable, retrouvée par son seul chemin enregistré (CA14, CA15) ;
- `cadrage-besoin-ca16-sans-argument`, `cadrage-besoin-ca17-chemin-inexistant`, `cadrage-besoin-ca17-format-docx`, `cadrage-besoin-ca17-pdf-scanne`, `cadrage-besoin-ca18-texte-saisi` : erreurs d'entrée (CA16 à CA18) ; le PDF « scanné » montre à l'œil un texte non extractible, qui ne doit pas être repris ;
- `cadrage-besoin-adr001-fichier-env-ecarte` : un fichier `.env*` passé en argument (même en `.md`) est écarté sans être ouvert (ADR-001) ;
- `cadrage-besoin-ca19-coordonnees` : coordonnées, identifiant et mot de passe dans la source ; source dans un sous-dossier, listée par son chemin relatif dans l'en-tête, aucun chemin absolu (CA19, CA3) ;
- `cadrage-besoin-ca03-source-hors-projet` : source hors du projet, créée par le scaffold dans le répertoire parent et passée en `../briefs-externes/brief-externe.md`, gardée en relatif dans l'en-tête, aucun chemin absolu (CA3). Le bac à sable de l'eval n'autorise la lecture que sous ce parent (`home/`, la session tournant dans `home/cwd`) ; la conversion d'un argument absolu en chemin relatif n'est pas testable par une eval, le chemin absolu de la session n'étant pas connu à l'avance ;
- `cadrage-besoin-ca20-source-anglaise` : source en anglais, priorités « essential » et « optional » (CA20, CA5) ;
- `cadrage-besoin-ca22-projet-avec-code` : projet cible avec code et git, aucun fichier de `src/` ni `mobile/` lu (CA22, CA3, faux secret de l'ADR-001).

### wf-revue-securite

Spec 010, lancée par `/wf-revue-securite` (tag `wf-revue-securite` pour ne lancer qu'eux). Chaque grader porte l'identifiant du CA qu'il vérifie (`ca12-…`) ; les graders `temoin-…` vérifient que le scaffold a bien planté la faille ou la valeur dont un grader d'absence vérifie qu'elle n'est pas reprise. Les failles propres à un cas sont plantées par son `scaffold.sh` et commitées (arbre propre), avec des valeurs manifestement factices (`FAUX_…`) ; celles du FieldOps commun sont décrites dans `tests/fixtures/README.md`. Les trois cas `reseau` ont besoin d'OSV.dev (et de pub.dev pour le cas pub) : la passe `reseau` accorde `WebFetch(domain:api.osv.dev)`. Les commandes d'interrogation de la skill sont aussi exécutées par le test structurel, curl simulé, avec un nom de paquet hostile.

| Cas | Projet de départ | Tag | CA |
|---|---|---|---|
| `revue-securite-fieldops` | FieldOps complet (web et Flutter), propre ; ajouts : body-parser 1.20.1 transitive via express dans `package-lock.json`, clé littérale dans `mobile/lib/services/map_service.dart` | `reseau` | CA1 à CA6, CA9 à CA15, CA17, CA18, CA24 |
| `revue-securite-ca05-ca06-transitive-pub` | application Flutter fictive : http 0.12.2 transitive via google_fonts 1.1.0 (avis réel GHSA-4rgh-jx4f-qfcq / CVE-2020-35669, corrigé en 0.13.3) | `reseau` | CA5, CA6 (pub) |
| `revue-securite-ca07-sans-lockfile` | FieldOps web seul, `package-lock.json` retiré | `reseau` | CA7 |
| `revue-securite-ca01-lockfile-hostile` | FieldOps complet, entrée `x'$(touch${IFS}pwned)'` dans `package-lock.json` | `hors-reseau` | CA1, ADR-001 (aucune exécution d'un nom de paquet) |
| `revue-securite-ca08-ca16-base-injoignable` | FieldOps complet, `.env.staging` suivi par git (marqueur factice) | `hors-reseau` | CA8, CA16, CA17, CA1 |
| `revue-securite-ca19-aucun-constat` | petit projet TypeScript sous git, sans dépendance ni faille | `hors-reseau` | CA19, CA2 |
| `revue-securite-ca20-relance` | FieldOps complet et livrable précédent commité (S2, S4, S7, S9 ; dernier identifiant S11) | `hors-reseau` | CA20 |
| `revue-securite-ca22-stack-mixte` | FieldOps complet et outil d'import Python (`outils/import/`) | `hors-reseau` | CA22 |
| `revue-securite-ca23-repertoire-vide` | répertoire vide | `hors-reseau` | CA23 (cas limite) |
| `revue-securite-ca23-sans-code-source` | FieldOps brief (documents seuls) | `hors-reseau` | CA23 (cas limite) |
| `revue-securite-ca25-projet-volumineux` | FieldOps et 2 000 modules générés sous `src/legacy/`, dont un porteur d'une injection et d'un jeton factices | `hors-reseau` | CA25 |

- Commit attendu dans l'en-tête du cas principal : `fc765ad` (HEAD du scaffold, rejouable). Une modification de la fixture ou du scaffold le change : mettre à jour `ca03-en-tete-commit`.
- CA8 : comme pour `wf-analyse-projet`, la base est coupée par le bac à sable (passe `hors-reseau`) ; le témoin `ca08-temoin-echec-reseau` exige dans la trace la sortie d'une interrogation échouée (`osv.dev injoignable (curl <code>…)`). Tous les cas `hors-reseau` qui ont des dépendances exercent donc aussi CA8.
- Les avis évoluent (ADR-001) : seuls des avis publiés de longue date sont attendus (express 4.18.2, body-parser 1.20.1), et jamais une sévérité ou une version corrigée précise.
- CA14 : « aucun caractère de la valeur » est vérifié sur la valeur entière et ses fragments distinctifs (`dev-secret`, `FAUX_JETON`, `c41d`), pas lettre par lettre.
- CA21 (contrat lu par `wf-montee-version`) est vérifié par les tests structurels (`tests/skills/wf-revue-securite.sh`), pas par une eval.
- Les motifs des graders sont compilés et vérifiés sur des exemples positifs et négatifs par `tests/correcteurs/wf-revue-securite.mjs`, lancé par `tests/skills.sh`.

### wf-modele-donnees

Spec 017, lancée par `/wf-modele-donnees`, tous les cas `hors-reseau` (tags `wf-modele-donnees` et `spec-017`). Chaque grader, déclaré dans `case.yaml`, porte l'identifiant du CA qu'il vérifie (`ca04-…`) ; un grader « témoin » vérifie que le livrable a bien été écrit ou mis à jour. Les données propres à un cas sont dans son dossier `donnees/`. Livraison en trois PR (niveau A, puis B, puis C) : cette version couvre les CA communs et les trois niveaux.

| Cas | Projet de départ | CA |
|---|---|---|
| `modele-donnees-ca17-brief-niveau-a` | FieldOps brief, brief et notes d'appel en argument | CA17, CA1 à CA9, CA12 à CA15 |
| `modele-donnees-ca18-cadrage-sans-argument` | FieldOps brief et `docs/wf/cadrage-besoin.md` (contrat de la spec 004), sans argument | CA18, CA1, CA2, CA4 |
| `modele-donnees-ca10-ca11-relance-niveau-a` | FieldOps brief et livrable de niveau A : réponse à Q01 et décision D01 saisies, question bloquante Q03 vide, identifiants retirés | CA10, CA11, CA20, CA1 |
| `modele-donnees-ca33-sans-argument` | FieldOps brief, ni argument, ni cadrage, ni livrable | CA33 (cas limite) |
| `modele-donnees-ca34-niveau-invalide` | FieldOps brief, `--niveau z` | CA34 (cas limite, valeur invalide) |
| `modele-donnees-ca35-ca38-sources-ecartees` | FieldOps brief, fichier introuvable et `.docx` en argument, fichier d'environnement avec chaîne de connexion et faux secret | CA35, CA38 (cas limites) |
| `modele-donnees-ca19-niveau-b-postgresql` | FieldOps brief, livrable de niveau A rempli (Q01, Q03, D01) et ancienne `migration.sql` sans objet, aucun ORM | CA19, CA3, CA10, CA13 à CA16, CA22 à CA24, CA37 |
| `modele-donnees-ca21-niveau-b-force` | livrable de niveau A du cas de relance (Q03 vide), `--niveau b` | CA21, CA10 |
| `modele-donnees-ca25-prisma` | projet web dépendant de Prisma, sans schéma, livrable de niveau A rempli | CA25, CA1, CA15, CA16 |
| `modele-donnees-ca26-evolution-fieldops` | FieldOps complet (schéma PostgreSQL, base sqflite, faux secret), notes d'appel passées en `../fieldops-brief/notes-appel.md` | CA26, CA27, CA31, CA1 à CA3, CA15, CA16, CA38 |
| `modele-donnees-ca28-ca32-migration-sans-perte` | FieldOps complet, demande d'évolution en `../demandes/` : priorité obligatoire, renommage de `report`, `hourly_rate` inutile | CA28 à CA32, CA27, CA14 (écarts aux conventions), CA1, CA15, CA16 |
| `modele-donnees-ca30-suppression-decidee` | FieldOps complet, même demande, livrable de niveau C dont D01 confirme la suppression de `hourly_rate` | CA30 (suppression confirmée), CA10, CA29 |
| `modele-donnees-ca34-niveau-c-sans-schema` | FieldOps brief, `--niveau c` | CA34 (cas limite, sans schéma) |

Les cas `ca21` et `ca25` reprennent le livrable de niveau A d'un autre cas (`donnees/` du cas de relance ou du cas `ca19`), et `ca30` la demande d'évolution du cas `ca28-ca32` : les modifier change aussi ces cas.

Niveau C : les sources sont placées par le scaffold dans le répertoire parent de la session (`../fieldops-brief/`, `../demandes/`), seul emplacement hors du projet que le bac à sable de l'eval laisse lire ; l'arbre de travail de FieldOps reste donc propre, et l'en-tête porte le commit `2fc99c0` sans « modifications non commitées ».

Les vérifications croisées entre fichiers (index justifiés par une requête, données de test qui respectent le schéma et rendent une ligne à chaque requête) sont confiées à un juge `llm` sur la trace, qui contient le contenu de chaque appel Write : aucun fichier n'est exécuté (ADR-001, amendement 2), le juge raisonne sur le texte.

Non couverts par une eval : CA25 pour TypeORM, Drift et sqflite (un seul ORM, Prisma, est joué ; les formats des quatre sont vérifiés par les tests structurels), CA36 (ORM non couvert, tests structurels seulement), et au niveau C les migrations Prisma, TypeORM, Drift et SQL numérotées (FieldOps n'a ni ORM ni outil de migration).

Non couverts par une eval : CA25 pour TypeORM, Drift et sqflite (un seul ORM, Prisma, est joué ; les formats des quatre sont vérifiés par les tests structurels), CA36 (ORM non couvert, tests structurels seulement).

Non couverts par une eval à ce stade : CA16 (aucun fichier non Markdown au niveau A) et CA37 (aucun fichier à signaler avant les niveaux B et C), couverts par les tests structurels et repris avec les niveaux suivants.

- `cadrage-besoin-ca22-projet-avec-code` : projet cible avec code et git, aucun fichier de `src/` ni `mobile/` lu (CA22, CA3, faux secret de l'ADR-001) ;
- `cadrage-besoin-argument-piege` : un brief lisible et un fichier nommé avec une substitution de commande (`$(touch pwned)`) ; le fichier piégé est refusé sans être lu ni cité dans une commande, rien n'est exécuté, le refus est signalé (amendement de CA17) ;
- `cadrage-besoin-argument-delimiteur-heredoc` : un argument égal au délimiteur du heredoc des sources (`WF_SOURCES_7c3e`), suivi de `x;touch pwned` ; l'argument est refusé avant tout appel au shell, le heredoc n'est pas fermé avant la fin, rien n'est exécuté (amendement de CA17) ;
- `cadrage-besoin-relance-source-delimiteur-heredoc` : relance sans argument, le délimiteur et `x;touch pwned` figurent dans « Sources lues » ; même refus, la source refusée est retirée de l'en-tête (amendement de CA17) ;
- `cadrage-besoin-argument-multiligne` : un argument sur deux lignes, dont la première désigne un fichier existant ; l'argument est refusé en entier, ni lu, ni cité dans une commande, ni découpé en deux chemins (amendement de CA17).

Pour `cadrage-besoin-ca20-source-anglaise`, la langue du livrable est vérifiée par deux motifs au lieu d'un juge `llm`, qui échouait sur un livrable conforme : aucun mot-outil anglais, et aucun terme propre au brief anglais (titre, rôles, libellés), hors citation entre « ».

Les motifs des correcteurs de ces cas sont vérifiés sans modèle, sur des exemples positifs et négatifs, par `tests/correcteurs/wf-cadrage-besoin.mjs` (lancé par `tests/skills.sh`).
