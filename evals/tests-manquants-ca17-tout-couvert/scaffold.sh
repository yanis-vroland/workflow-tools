#!/usr/bin/env bash
# Spec 012, CA17 : petit module TypeScript entièrement couvert. Chaque fichier
# source a son fichier de test (Vitest), et chaque branche (calcul nominal,
# taux négatif, taux supérieur à 1) est déclenchée par un test. Dépôt git avec
# un commit, arbre propre.
set -euo pipefail

if [ -n "$(ls -A .)" ]; then
  echo "Le répertoire de travail de l'eval devrait être vide." >&2
  exit 1
fi

mkdir -p src

cat >package.json <<'JSON'
{
  "name": "fieldops-remises",
  "version": "1.0.0",
  "private": true,
  "description": "Calcul des remises commerciales sur les interventions.",
  "scripts": {
    "test": "vitest run"
  },
  "devDependencies": {
    "typescript": "^5.5.4",
    "vitest": "^2.0.5"
  }
}
JSON

cat >src/discount.ts <<'TS'
// Remise commerciale appliquée au montant d'une intervention

export function applyDiscount(amount: number, rate: number): number {
  if (rate < 0 || rate > 1) {
    throw new RangeError("Taux de remise hors de [0, 1]");
  }
  return amount - amount * rate;
}
TS

cat >src/discount.test.ts <<'TS'
import { describe, expect, it } from "vitest";
import { applyDiscount } from "./discount";

describe("applyDiscount", () => {
  it("retire la remise du montant", () => {
    expect(applyDiscount(100, 0.2)).toBe(80);
  });

  it("refuse un taux négatif", () => {
    expect(() => applyDiscount(100, -0.1)).toThrow(RangeError);
  });

  it("refuse un taux supérieur à 1", () => {
    expect(() => applyDiscount(100, 1.5)).toThrow(RangeError);
  });
});
TS

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_DATE="2026-09-01T09:00:00Z" GIT_COMMITTER_DATE="2026-09-01T09:00:00Z"
git -c init.defaultBranch=main init -q
git add -A
git -c user.name="FieldOps" -c user.email="fieldops@example.invalid" \
  -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -m "feat: remise commerciale"
