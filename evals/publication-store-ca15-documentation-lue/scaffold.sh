#!/usr/bin/env bash
# FieldOps complet (historique git et faux secret compris), lancé avec la
# documentation des stores joignable (passe reseau, WebFetch accordé sur
# developer.android.com et developer.apple.com). Spec 015, CA15 : page lue.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"
