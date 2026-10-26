#!/usr/bin/env bash
# Spec 013, CA18 : FieldOps complet ; l'argument (prompt.md) vise la version déjà installée d'express.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"
