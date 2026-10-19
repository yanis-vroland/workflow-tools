# Evals des skills

Evals lancées avec `claude plugin eval` (ADR-001, tests à deux niveaux). Chaque dossier est un cas : `case.yaml` (configuration et scaffold), `prompt.md`, et `graders/`.

## Lancer en local

Les cas se lancent en deux passes, selon leur tag réseau (voir « Réseau ») :

```bash
# Registres joignables (tag reseau)
claude plugin eval . --scaffold --trust-plugin --no-publish --judge-model sonnet --ablation none --tag reseau \
  --allow-tools Write Bash "WebFetch(domain:registry.npmjs.org)" "WebFetch(domain:pub.dev)"

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

- tag `reseau` : le cas a besoin des registres (npm, pub.dev) ;
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
| `doc-projet-ca08-modifications-non-commitees` | FieldOps web seul, `--dirty` | CA8 |
| `doc-projet-ca07-mise-a-jour` | FieldOps web seul et livrable fichier déjà commité | CA7 |
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
| `recette-ca17-reference-inconnue` | FieldOps et cahier précédent commité ; `/wf-recette v9.9.9` | CA17 (cas limite), CA21 |
| `recette-ca18-stack-non-couverte` | projet Python sans spec | CA18 (cas limite) |
| `recette-ca19-repertoire-vide` | répertoire vide | CA19 (cas limite) |
| `recette-ca19-sans-code-source` | FieldOps brief (documents seuls) | CA19 (cas limite) |

Tous les cas portent un correcteur `…-aucune-commande-hors-liste` : Bash ne sert qu'à `git rev-parse --short HEAD`, `git status --porcelain`, `date +%F` et, avec une référence, `git log -1 --format=%h <ref> --`, `git diff --name-only <ref> HEAD` et `git show <ref>:docs/wf/specs-tickets.md` (liste blanche). CA14 (synthèse exacte) est jugé par un correcteur `llm`, qui recompte le tableau.

Hash rejouables des scaffolds, vérifiés dans les en-têtes : `5b26289` (FieldOps complet), `b1aa967` (CA5), `b4342b5` (CA6), `4e279f7` (CA9-CA10), `2f42f56` (CA16, HEAD) et `6ac4b3b` (CA16, commit de `v1.3.0`). Une modification de la fixture ou d'un scaffold les change : mettre à jour les correcteurs `ca20-entete-commit` et `ca16-reference-et-commit`.

Limite : `file_exists` ne voit que les fichiers créés pendant l'exécution. Dans les cas où un cahier précédent est commité (CA9-CA10, CA17), l'écriture est vérifiée par l'outil Write (`tool_used`) et par un témoin de date, pas par `file_exists`.

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
