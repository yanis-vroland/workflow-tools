#!/usr/bin/env bash
# Spec 008, CA21 : FieldOps complet ; la période passée en argument est invalide
# (la date de début (2099-01-01) est postérieure à la date du jour). L'outil doit l'indiquer et n'écrire aucun
# livrable.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"
