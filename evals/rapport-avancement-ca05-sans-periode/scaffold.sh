#!/usr/bin/env bash
# Spec 008, CA5 : FieldOps complet, sans rapport précédent. Lancé sans période,
# l'outil doit demander la période et n'écrire aucun livrable.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"
