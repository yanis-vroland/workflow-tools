#!/usr/bin/env bash
# Spec 013, CA9 : FieldOps complet ; l'argument (prompt.md) désigne une version de react qui n'existe pas sur le registre.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"
