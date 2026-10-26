#!/usr/bin/env bash
# Spec 008, CA21 : FieldOps complet ; la période passée en argument a une date de
# fin antérieure à la date de début. L'outil doit l'indiquer et n'écrire aucun
# livrable.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"
