#!/usr/bin/env bash
# Copie de FieldOps hors git (spec 016, CA18), privée de toute configuration de
# déploiement : .github/, Dockerfile et docker-compose.yml retirés (CA6). Le
# README annonce toujours un déploiement par GitHub Actions
# (.github/workflows/deploy.yml, absent) : aucune procédure ne doit en être
# déduite. Les secrets ne sont plus référencés que par .env.example.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
cp -R "$repo/tests/fixtures/fieldops/." "$PWD/"
rm -r .github
rm Dockerfile docker-compose.yml
