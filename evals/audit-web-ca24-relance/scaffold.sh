#!/usr/bin/env bash
# Spec 011, CA24 : relance sur un livrable existant. Part de FieldOps web seul,
# dépose et commite un audit docs/wf/audit-web.md issu d'une exécution
# précédente (2026-09-15), puis corrige un des constats dans le code.
#
# Audit précédent :
#   - W1 : image sans alt, src/web/index.html ligne 10 : toujours présent ;
#   - W2 : <html> sans lang, src/web/index.html ligne 2 : corrigé par le dernier
#     commit (lang="fr"), doit être retiré ;
#   - W3 : page sans <title>, src/web/index.html : toujours présent ;
#   - W4 : champ sans libellé, src/web/pages/NewIntervention.tsx ligne 25 :
#     toujours présent ;
#   - W5 et W6 : retirés lors d'une exécution plus ancienne, portés par la ligne
#     « Dernier identifiant attribué : W6 » ; jamais réattribuables.
# Les constats que l'audit précédent n'avait pas relevés (src/web/pages/
# InterventionList.tsx lignes 23 et 34, meta description) doivent recevoir W7 et
# au-delà.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops-web.sh" "$PWD"

# commit_paths <date ISO> <message> <chemin>… : commit déterministe
commit_paths() {
  local date=$1 message=$2
  shift 2
  export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
  export GIT_AUTHOR_DATE="$date" GIT_COMMITTER_DATE="$date"
  git add -- "$@"
  git -c user.name="Nora Belkacem" -c user.email="nora.belkacem@example.invalid" \
    -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -m "$message"
}

mkdir -p docs/wf
cat >docs/wf/audit-web.md <<'MD'
# Audit web de FieldOps

Outil : wf-audit-web · Date : 2026-09-15 · Commit : 35377d4
Dernier identifiant attribué : W6

Cet audit a été établi par lecture du code, sans mesure : il ne vaut pas audit de conformité RGAA.

## Synthèse

Mode code seul : la performance réelle n'a pas été mesurée. Cet audit ne vaut pas audit de conformité RGAA.

| Catégorie | Élevé | Moyen | Faible |
|---|---|---|---|
| Performance | 0 | 0 | 0 |
| Accessibilité | 2 | 2 | 0 |
| Référencement | 0 | 0 | 0 |
| Bonnes pratiques | 0 | 0 | 0 |

## Périmètre et méthode

- Mode : code seul.
- Référentiel d'accessibilité : RGAA 4.1.
- Application auditée : back-office web (`src/web/`).

## Performance

Aucun constat.

## Accessibilité

### W1 — Image sans alternative textuelle

- Niveau : élevé
- Critère : RGAA 1.1 (WCAG 1.1.1)
- Emplacement : `src/web/index.html`, ligne 10
- Constat : la balise `<img>` du logo n'a pas d'attribut `alt`.
- Recommandation : ajouter un attribut `alt` décrivant le logo, ou `alt=""` s'il est décoratif.

### W2 — Langue de la page non déclarée

- Niveau : moyen
- Critère : RGAA 8.3 (WCAG 3.1.1)
- Emplacement : `src/web/index.html`, ligne 2
- Constat : la balise `<html>` n'a pas d'attribut `lang`.
- Recommandation : ajouter `lang="fr"`.

### W3 — Page sans titre

- Niveau : moyen
- Critère : RGAA 8.5 (WCAG 2.4.2)
- Emplacement : `src/web/index.html`, route `/`
- Constat : aucun élément `<title>` n'est défini.
- Recommandation : ajouter un `<title>` propre à la page.

### W4 — Champ de formulaire sans libellé

- Niveau : élevé
- Critère : RGAA 11.1 (WCAG 1.3.1, 4.1.2)
- Emplacement : `src/web/pages/NewIntervention.tsx`, ligne 25
- Constat : le champ de saisie de l'adresse n'a qu'un `placeholder`, sans `<label>` ni `aria-label`.
- Recommandation : associer un `<label htmlFor>` au champ.

## Référencement

Aucun constat.

## Bonnes pratiques

Aucun constat.

## Plan d'action

1. W1 (élevé, accessibilité) : ajouter une alternative au logo.
2. W4 (élevé, accessibilité) : libeller le champ d'adresse.
3. W2 (moyen, accessibilité) : déclarer la langue.
4. W3 (moyen, accessibilité) : donner un titre à la page.

## Points non déterminés

- Compression et cache HTTP : configurés chez l'hébergeur, non déterminés.
MD
commit_paths "2026-09-15T16:00:00Z" "docs: audit web (wf-audit-web)" docs/wf/audit-web.md

# Correction de W2 : <html lang="fr"> (même nombre de lignes)
sed 's|^<html>$|<html lang="fr">|' src/web/index.html >src/web/index.html.tmp
mv src/web/index.html.tmp src/web/index.html
commit_paths "2026-10-05T10:00:00Z" "fix(web): langue de la page déclarée" src/web/index.html
