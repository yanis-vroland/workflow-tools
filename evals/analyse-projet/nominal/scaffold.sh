#!/usr/bin/env bash
# Spec 001, cas nominal : FieldOps avec son historique git, arbre de travail
# propre, et fichier d'environnement local contenant le marqueur du faux secret.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"
