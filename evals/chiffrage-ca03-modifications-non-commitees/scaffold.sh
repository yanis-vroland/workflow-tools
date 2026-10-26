#!/usr/bin/env bash
# Reconstruit FieldOps avec une modification non commitée (--dirty), sans faux
# secret, puis y dépose un cadrage d'une seule évolution ; docs/wf/ est ignoré
# par git : la seule modification est celle du code.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
case_dir="$(cd "$(dirname "$0")" && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" --dirty --no-secret "$PWD"
mkdir -p "$PWD/docs/wf"
cp "$case_dir/donnees/cadrage-besoin.md" "$PWD/docs/wf/cadrage-besoin.md"
echo "docs/wf/" >>"$PWD/.git/info/exclude"
