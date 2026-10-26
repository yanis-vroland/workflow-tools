#!/usr/bin/env bash
# Reconstruit la fixture FieldOps (historique git et faux secret compris) dans le
# répertoire de travail de l'eval, vide au lancement, et place les notes d'appel
# de FieldOps brief à côté, dans ../fieldops-brief/ : le bac à sable de l'eval
# n'autorise la lecture que sous ce parent, la session tournant dans home/cwd.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"
mkdir -p "$PWD/../fieldops-brief"
cp "$repo/tests/fixtures/fieldops-brief/notes-appel.md" "$PWD/../fieldops-brief/notes-appel.md"
