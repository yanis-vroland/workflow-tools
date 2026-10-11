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

Les hash de commit attendus dans les en-têtes sont ceux des scaffolds, rejouables : `5b26289` (FieldOps complet), `35377d4` (web seul), `903dded` (cas CA7). Une modification de la fixture les change : mettre à jour les graders `ca08-…` et `ca07-en-tete-…`.

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
- `cadrage-besoin-ca19-coordonnees` : coordonnées, identifiant et mot de passe dans la source ; source dans un sous-dossier, listée par son chemin dans l'en-tête (CA19, CA3) ;
- `cadrage-besoin-ca20-source-anglaise` : source en anglais, priorités « essential » et « optional » (CA20, CA5) ;
- `cadrage-besoin-ca22-projet-avec-code` : projet cible avec code et git, aucun fichier de `src/` ni `mobile/` lu (CA22, CA3, faux secret de l'ADR-001).
