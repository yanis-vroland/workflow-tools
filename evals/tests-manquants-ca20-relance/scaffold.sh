#!/usr/bin/env bash
# Spec 012, CA20 : FieldOps complet avec un livrable docs/wf/tests-manquants.md
# déjà présent, issu d'une exécution précédente, puis un test écrit depuis :
#   - M1 (src/api/routes/interventions.ts) et M3
#     (mobile/lib/screens/intervention_list_screen.dart) restent sans test ;
#   - M2 (src/domain/scheduling.ts) a désormais son test
#     (src/domain/scheduling.test.ts) : l'entrée doit être retirée ;
#   - M4, déjà retiré lors d'une exécution antérieure, est le dernier
#     identifiant attribué : aucun des deux (M2, M4) ne doit être réattribué,
#     les nouvelles entrées commencent à M5.
# Le livrable précédent n'a pas de ligne « Application : » dans ses entrées
# (version antérieure) : les graders qui vérifient la conservation de M1 et M3
# exigent cette ligne, pour ne pas réussir sur le livrable déposé tel quel.
# Le livrable et le test sont commités (commit déterministe) : arbre propre.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

cat >src/domain/scheduling.test.ts <<'TS'
import { describe, expect, it } from "vitest";
import { overlaps } from "./scheduling";

describe("overlaps", () => {
  it("détecte deux créneaux qui se chevauchent", () => {
    const a = { startsAt: new Date("2026-10-01T08:00:00Z"), endsAt: new Date("2026-10-01T10:00:00Z") };
    const b = { startsAt: new Date("2026-10-01T09:00:00Z"), endsAt: new Date("2026-10-01T11:00:00Z") };
    expect(overlaps(a, b)).toBe(true);
  });
});
TS

mkdir -p docs/wf
cat >docs/wf/tests-manquants.md <<'MD'
# Tests à écrire en priorité

Outil : wf-tests-manquants · Date : 2026-10-02 · Commit analysé : 0000000
Dernier identifiant attribué : M4


## Synthèse

Deux applications, peu testées : trois entrées retenues.

## Outillage de test

### Application web (racine)

- Framework : Vitest (`package.json`, `vite.config.ts`)
- Commande : `npm test` (script `test` de `package.json`)
- Fichiers de test : 1

### Application Flutter (`mobile/`)

- Framework : flutter_test (`mobile/pubspec.yaml`)
- Commande : `flutter test`
- Fichiers de test : 1 dans `mobile/test/`, 0 dans `mobile/integration_test/`

## Couverture actuelle

### Application web (racine)

- Source : heuristique approximative (aucun rapport de couverture).

### Application Flutter (`mobile/`)

- Source : heuristique approximative (aucun rapport de couverture).

## Tests manquants

### M1 · `src/api/routes/interventions.ts`

- À tester : `interventionsRouter`
- Type de test : intégration
- Priorité : haute
- Justification : non couvert et parmi les 10 fichiers les plus modifiés sur 12 mois.
- Commits sur 12 mois : 6

### M3 · `mobile/lib/screens/intervention_list_screen.dart`

- À tester : `InterventionListScreen`
- Type de test : widget
- Priorité : haute
- Justification : non couvert et parmi les 10 fichiers les plus modifiés sur 12 mois.
- Commits sur 12 mois : 4

### M2 · `src/domain/scheduling.ts`

- À tester : `overlaps`, `isAvailable`, `suggestTechnician`
- Type de test : unitaire
- Priorité : moyenne
- Justification : fonctions publiques avec branches conditionnelles.
- Commits sur 12 mois : 1

## Cas manquants dans le code testé

Aucun cas manquant identifié.

## Squelettes de tests

Squelettes à reprendre de l'exécution précédente.

## Points non déterminés

- Aucun.
MD

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_NAME="Hugo Brassac" GIT_AUTHOR_EMAIL="hugo.brassac@example.invalid"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME" GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
export GIT_AUTHOR_DATE="2026-10-05T10:00:00Z" GIT_COMMITTER_DATE="2026-10-05T10:00:00Z"
git -c core.hooksPath=/dev/null add docs/wf/tests-manquants.md src/domain/scheduling.test.ts
git -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q \
  -m "test(planning): chevauchement de deux créneaux (M2)"
