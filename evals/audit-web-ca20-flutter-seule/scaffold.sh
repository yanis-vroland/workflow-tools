#!/usr/bin/env bash
# Spec 011, CA20 : application Flutter seule, sans front web JS/TS. Copie de
# l'application compagnon de FieldOps (tests/fixtures/fieldops/mobile/) à la
# racine du répertoire de travail, hors git. L'outil doit l'indiquer et n'écrire
# aucun livrable.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
cp -R "$repo/tests/fixtures/fieldops/mobile/." "$PWD/"
