# Evals des skills

Evals lancées avec `claude plugin eval` (ADR-001, tests à deux niveaux). Chaque dossier est un cas : `case.yaml` (configuration et scaffold), `prompt.md`, et `graders/`.

## Lancer en local

Les cas se lancent en deux passes, selon leur tag réseau (voir « Réseau ») :

```bash
# Registres joignables (tag reseau)
claude plugin eval . --scaffold --trust-plugin --no-publish --judge-model sonnet --ablation none --tag reseau \
  --allow-tools Write Bash "WebFetch(domain:registry.npmjs.org)" "WebFetch(domain:pub.dev)" "WebFetch(domain:api.osv.dev)"

  --allow-tools Write Bash "WebFetch(domain:registry.npmjs.org)" "WebFetch(domain:pub.dev)" \
  "WebFetch(domain:endoflife.date)" "WebFetch(domain:storage.googleapis.com)"

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

- tag `reseau` : le cas a besoin des registres (npm, pub.dev) ou de la base d'avis OSV.dev (`api.osv.dev`) ;

- tag `reseau` : le cas a besoin des registres (npm, pub.dev) ou des calendriers de versions (endoflife.date, versions publiées de Flutter sur `storage.googleapis.com`) ;
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
