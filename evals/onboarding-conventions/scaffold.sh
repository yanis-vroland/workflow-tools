#!/usr/bin/env bash
# Petit projet TypeScript fictif, hors git, qui définit ses conventions de
# contribution (spec 003, CA9) :
#   - CONTRIBUTING.md : nommage des branches (ticket/<numéro>-<sujet-court>)
#     et format des commits (Conventional Commits, portée obligatoire) ;
#   - commitlint.config.js : vérification du format des commits ;
#   - .husky/commit-msg : hook git qui lance commitlint ;
#   - scripts lint et format de package.json, avec leur configuration.
set -euo pipefail

mkdir -p src .husky

cat >README.md <<'MD'
# FieldOps Planning

Planification des créneaux d'atelier pour les techniciens FieldOps.

## Installation

```bash
npm ci
```

## Lancement

```bash
npm run dev
```

Voir `CONTRIBUTING.md` pour contribuer.
MD

cat >CONTRIBUTING.md <<'MD'
# Contribuer à FieldOps Planning

## Branches

Une branche par ticket, créée depuis `develop` et nommée
`ticket/<numéro>-<sujet-court>` (ex. `ticket/42-export-csv`).

## Commits

Messages au format Conventional Commits, portée obligatoire :
`<type>(<portée>): <résumé>` (ex. `feat(planning): filtre par atelier`).
Le format est vérifié à chaque commit par commitlint (`commitlint.config.js`).

## Avant d'ouvrir une demande de fusion

`npm run lint` et `npm test` doivent passer.
MD

cat >commitlint.config.js <<'JS'
module.exports = {
  extends: ["@commitlint/config-conventional"],
  rules: {
    "scope-empty": [2, "never"],
  },
};
JS

cat >.husky/commit-msg <<'SH'
npx --no -- commitlint --edit "$1"
SH

cat >.prettierrc.json <<'JSON'
{
  "singleQuote": false,
  "printWidth": 100
}
JSON

cat >eslint.config.js <<'JS'
module.exports = [
  {
    files: ["src/**/*.ts"],
    rules: { "no-console": "error" },
  },
];
JS

cat >package.json <<'JSON'
{
  "name": "fieldops-planning",
  "version": "0.3.0",
  "private": true,
  "scripts": {
    "dev": "tsx watch src/index.ts",
    "test": "vitest run",
    "lint": "eslint src",
    "format": "prettier --write src",
    "prepare": "husky"
  },
  "devDependencies": {
    "@commitlint/cli": "^19.0.0",
    "@commitlint/config-conventional": "^19.0.0",
    "eslint": "^9.0.0",
    "husky": "^9.0.0",
    "prettier": "^3.2.0",
    "tsx": "^4.6.0",
    "typescript": "^5.3.2",
    "vitest": "^1.0.1"
  }
}
JSON

cat >tsconfig.json <<'JSON'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "strict": true
  },
  "include": ["src"]
}
JSON

cat >src/models.ts <<'TS'
/** Créneau d'atelier réservé à un technicien, en minutes depuis minuit. */
export interface Slot {
  id: number;
  workshop: string;
  startMinute: number;
  endMinute: number;
}
TS

cat >src/planning.ts <<'TS'
import { Slot } from "./models";

export function overlaps(a: Slot, b: Slot): boolean {
  return a.workshop === b.workshop && a.startMinute < b.endMinute && b.startMinute < a.endMinute;
}
TS

cat >src/planning.test.ts <<'TS'
import { describe, expect, it } from "vitest";
import { overlaps } from "./planning";

describe("overlaps", () => {
  it("détecte deux créneaux qui se chevauchent dans le même atelier", () => {
    const a = { id: 1, workshop: "A", startMinute: 480, endMinute: 540 };
    const b = { id: 2, workshop: "A", startMinute: 510, endMinute: 600 };
    expect(overlaps(a, b)).toBe(true);
  });
});
TS

cat >src/index.ts <<'TS'
import { overlaps } from "./planning";

const morning = { id: 1, workshop: "A", startMinute: 480, endMinute: 540 };
const late = { id: 2, workshop: "A", startMinute: 600, endMinute: 660 };
process.stdout.write(`Chevauchement : ${overlaps(morning, late)}\n`);
TS
