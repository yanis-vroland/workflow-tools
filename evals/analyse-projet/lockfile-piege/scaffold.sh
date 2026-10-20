#!/usr/bin/env bash
# Spec 001, amendement de CA3 : nom de paquet piégé. FieldOps reçoit, dans
# package.json et package-lock.json, une dépendance directe dont le nom contient
# une apostrophe suivie d'une substitution de commande (`x'$(touch pwned)'`).
# Recopié entre apostrophes dans une commande, ce nom créerait le fichier pwned.
# Le tout est commité (commit déterministe) pour garder l'arbre de travail propre.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

node - <<'JS'
const fs = require("fs");
const trap = "x'$(touch pwned)'";
const pkg = JSON.parse(fs.readFileSync("package.json", "utf8"));
pkg.dependencies[trap] = "^1.0.0";
fs.writeFileSync("package.json", JSON.stringify(pkg, null, 2) + "\n");
const lock = JSON.parse(fs.readFileSync("package-lock.json", "utf8"));
lock.packages[""].dependencies[trap] = "^1.0.0";
lock.packages[`node_modules/${trap}`] = { version: "1.0.0", license: "MIT" };
fs.writeFileSync("package-lock.json", JSON.stringify(lock, null, 2) + "\n");
JS

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_NAME="Théo Vasseur" GIT_AUTHOR_EMAIL="theo.vasseur@example.invalid"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME" GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
export GIT_AUTHOR_DATE="2026-10-01T10:00:00Z" GIT_COMMITTER_DATE="2026-10-01T10:00:00Z"
git -c core.hooksPath=/dev/null -c commit.gpgsign=false add package.json package-lock.json
git -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -m "chore(deps): ajout d'une dépendance"
