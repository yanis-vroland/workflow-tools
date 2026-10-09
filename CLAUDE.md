# CLAUDE.md

## Projet

Plugin Claude Code (public à partir de la v1) : 16 outils de workflow (`wf-doc-projet`, `wf-analyse-projet`, `wf-chiffrage`…) pour le quotidien d'un chef de projet et développeur freelance web et mobile. Chaque outil est une skill lancée *dans* le projet cible, et écrit son livrable dans ce projet, jamais dans ce dépôt.

## Stack et commandes

- Installer en local : `claude --plugin-dir .`
- Tests des garde-fous : `bash tests/hooks.sh && bash tests/pre-commit.sh && bash tests/verifier-revue-ia.sh && bash tests/skills.sh`

## Langue

- Code en anglais : variables, fonctions, classes, entités, tables, routes d'API.
- Tout le reste en français : README, ADR, specs, commentaires, messages de commit, PR.
- Commits au format Conventional Commits, préfixe en anglais, message en français :
  `feat: ajout du CRUD des machines`

## Méthode de travail

1. Toute modification du comportement observable exige une spec validée dans `docs/specs/` :
   - nouvelle fonctionnalité (feat) : nouvelle spec ;
   - correction (fix) : référence à la spec concernée et test de non-régression qui échoue avant la correction ; si le bug révèle un cas non prévu, compléter d'abord la spec ;
   - sans changement de comportement (refactor, perf, test, chore, ci, docs) : la description de la PR suffit. Si le changement modifie un comportement malgré son préfixe, il relève des cas précédents.

   Pour les deux premiers cas, sans spec, proposer d'en rédiger une et attendre la validation.
2. Test-first ([ADR-003](https://github.com/yanis-vroland/agentic-dev-workflow/blob/main/docs/adr/003-strategie-test-first.md)) :
   - écrire les tests à partir des critères d'acceptation (subagent `test-writer`), vérifier qu'ils échouent pour la bonne raison, et les committer avant l'implémentation, dans un commit séparé ;
   - relire les tests avant d'implémenter, et renforcer toute vérification qui passerait sans implémentation ;
   - implémenter jusqu'au vert ;
   - sur les garde-fous (hooks, scripts de sécurité, vérifications de CI), contrôle par mutation : désactiver chaque protection une fois et vérifier qu'au moins un test échoue.
3. Ne jamais modifier ou supprimer un test pour le faire passer sans le signaler explicitement.
4. Face à un choix d'architecture structurant, s'arrêter et proposer un ADR dans `docs/adr/` au lieu de trancher seul. L'agent peut rédiger l'ADR en entier, au statut « proposé » ; il ne passe à « accepté » et n'est mergé qu'après validation humaine ([ADR-002](https://github.com/yanis-vroland/agentic-dev-workflow/blob/main/docs/adr/002-place-revue-humaine.md)).

## Définition du « done »

- Chaque critère d'acceptation de la spec est couvert par au moins un test.
- Lint, format et tests au vert.
- Aucun TODO sans ticket associé.
- Documentation mise à jour si un comportement public change.

## Interdits

- Lire, créer ou modifier un fichier `.env*`, sauf `.env.example`.
- Committer un secret, une clé ou un token.
- Ajouter une dépendance sans la justifier dans la PR.
- Pousser directement sur `main`.
- Merger une PR : seul l'humain merge ([ADR-002](https://github.com/yanis-vroland/agentic-dev-workflow/blob/main/docs/adr/002-place-revue-humaine.md)).

## Architecture

- `.claude-plugin/plugin.json` : manifeste du plugin publié.
- `skills/wf-<outil>/SKILL.md` : un outil du plugin = une skill, nommée `wf-<nom-en-français>`.
- `.claude/` : outillage de développement de ce dépôt (chaîne agentic-dev-workflow), non publié avec le plugin.

## Confidentialité

Dépôt destiné à être public (privé jusqu'à la v1), mais outils utilisés sur des projets clients réels :
- aucun livrable produit sur un vrai projet n'entre dans ce dépôt ;
- exemples, démos et tests uniquement sur des données fictives (FieldOps) ou des dépôts publics ;
- aucun nom de client ni d'employeur (Misyl, Kozykod, BOXBOXBOX…) dans le code, les docs ou les commits.
