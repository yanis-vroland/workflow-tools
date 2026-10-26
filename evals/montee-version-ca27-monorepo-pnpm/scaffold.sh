#!/usr/bin/env bash
# Spec 013, CA27 : monorepo pnpm fictif « FieldOps Portails », dépôt git avec
# un commit déterministe. Deux applications (espaces de travail) :
# - apps/web : react et react-dom 17.0.2, scripts test et build ;
# - apps/admin : react et react-dom 18.2.0, script build seul.
# La même dépendance (react) y est installée à deux versions différentes.
# Node.js 20.11.1 est fixé par .node-version (CA4).
set -euo pipefail

mkdir -p apps/web/src apps/admin/src

cat >package.json <<'JSON'
{
  "name": "fieldops-portails",
  "private": true,
  "engines": {
    "node": ">=20"
  },
  "packageManager": "pnpm@9.12.0"
}
JSON

printf '20.11.1\n' >.node-version

cat >pnpm-workspace.yaml <<'YAML'
packages:
  - "apps/*"
YAML

cat >apps/web/package.json <<'JSON'
{
  "name": "@fieldops/web",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "test": "vitest run",
    "build": "vite build"
  },
  "dependencies": {
    "dayjs": "^1.11.10",
    "react": "^17.0.2",
    "react-dom": "^17.0.2"
  },
  "devDependencies": {
    "vite": "^5.0.4",
    "vitest": "^1.0.1"
  }
}
JSON

cat >apps/admin/package.json <<'JSON'
{
  "name": "@fieldops/admin",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "build": "vite build"
  },
  "dependencies": {
    "dayjs": "^1.11.10",
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "vite": "^5.0.4"
  }
}
JSON

cat >pnpm-lock.yaml <<'YAML'
lockfileVersion: '9.0'

settings:
  autoInstallPeers: true
  excludeLinksFromLockfile: false

importers:

  .: {}

  apps/admin:
    dependencies:
      dayjs:
        specifier: ^1.11.10
        version: 1.11.10
      react:
        specifier: ^18.2.0
        version: 18.2.0
      react-dom:
        specifier: ^18.2.0
        version: 18.2.0(react@18.2.0)
    devDependencies:
      vite:
        specifier: ^5.0.4
        version: 5.0.4

  apps/web:
    dependencies:
      dayjs:
        specifier: ^1.11.10
        version: 1.11.10
      react:
        specifier: ^17.0.2
        version: 17.0.2
      react-dom:
        specifier: ^17.0.2
        version: 17.0.2(react@17.0.2)
    devDependencies:
      vite:
        specifier: ^5.0.4
        version: 5.0.4
      vitest:
        specifier: ^1.0.1
        version: 1.0.1

packages:

  dayjs@1.11.10:
    resolution: {integrity: sha512-fictif-dayjs}

  react-dom@17.0.2:
    resolution: {integrity: sha512-fictif-react-dom-17}
    peerDependencies:
      react: 17.0.2

  react-dom@18.2.0:
    resolution: {integrity: sha512-fictif-react-dom-18}
    peerDependencies:
      react: ^18.2.0

  react@17.0.2:
    resolution: {integrity: sha512-fictif-react-17}
    engines: {node: '>=0.10.0'}

  react@18.2.0:
    resolution: {integrity: sha512-fictif-react-18}
    engines: {node: '>=0.10.0'}

  vite@5.0.4:
    resolution: {integrity: sha512-fictif-vite}
    engines: {node: ^18.0.0 || >=20.0.0}
    hasBin: true

  vitest@1.0.1:
    resolution: {integrity: sha512-fictif-vitest}
    engines: {node: ^18.0.0 || >=20.0.0}
    hasBin: true

snapshots:

  dayjs@1.11.10: {}

  react-dom@17.0.2(react@17.0.2):
    dependencies:
      react: 17.0.2

  react-dom@18.2.0(react@18.2.0):
    dependencies:
      react: 18.2.0

  react@17.0.2: {}

  react@18.2.0: {}

  vite@5.0.4: {}

  vitest@1.0.1: {}
YAML

cat >apps/web/src/main.tsx <<'TSX'
import React from "react";
import ReactDOM from "react-dom";

const App = () => <h1>Portail des techniciens</h1>;

ReactDOM.render(<App />, document.getElementById("root"));
TSX

cat >apps/admin/src/main.tsx <<'TSX'
import React from "react";
import { createRoot } from "react-dom/client";

const App = () => <h1>Administration des portails</h1>;

createRoot(document.getElementById("root")!).render(<App />);
TSX

printf 'node_modules/\ndist/\n' >.gitignore

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_DATE="2026-09-15T09:00:00Z" GIT_COMMITTER_DATE="2026-09-15T09:00:00Z"
git -c init.defaultBranch=main init -q
git add -A
git -c user.name="FieldOps" -c user.email="fieldops@example.invalid" \
  -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -m "feat: portails web et administration"
