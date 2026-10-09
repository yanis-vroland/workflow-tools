# Evals des skills

Evals lancées avec `claude plugin eval` (ADR-001, tests à deux niveaux). Chaque dossier est un cas : `case.yaml` (configuration et scaffold), `prompt.md`, et `graders/`.

## Lancer en local

```bash
claude plugin eval . --scaffold --trust-plugin --no-publish --allow-tools Write Bash
```

- `--scaffold` : nécessaire pour que chaque cas reconstruise sa fixture (`tests/fixtures/build-fieldops.sh`).
- `--allow-tools Write Bash` : les outils déclarés dans `allowed_tools` doivent aussi être accordés au lancement.
- `--no-publish` : toujours. Le rapport reste local, dans `evals/results/` (ignoré par git).
- `--case <nom>` pour un seul cas, `--runs 1` et `--ablation none` pour un essai rapide.

## En CI

Le workflow `.github/workflows/evals.yml` ne tourne que sur une PR de ce dépôt portant le label `evals`.

## Cas

- `socle-fixture` : cas d'essai de la chaîne, sans skill. Vérifie que le scaffold reconstruit FieldOps (historique, tags, faux secret) et que les graders lisent un livrable sous `docs/wf/` et la trace.
