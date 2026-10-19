#!/usr/bin/env bash
# Spec 012, CA19 : FieldOps complet augmenté d'un service Python (relay/), stack
# non couverte en v1, sans aucun test. Projet mixte : les parties JS/TS et
# Flutter restent analysées normalement, la partie Python est signalée « non
# couverte » sans aucune entrée. Commit déterministe, arbre propre.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

mkdir -p relay/relay

cat >relay/pyproject.toml <<'TOML'
[project]
name = "fieldops-relay"
version = "0.3.0"
requires-python = ">=3.11"
dependencies = ["httpx>=0.27"]

[project.optional-dependencies]
dev = ["pytest>=8"]
TOML

cat >relay/relay/__init__.py <<'PY'
PY

cat >relay/relay/routing.py <<'PY'
# Choix du canal de notification d'un technicien


def pick_channel(technician: dict) -> str:
    if technician.get("push_token"):
        return "push"
    if technician.get("phone"):
        return "sms"
    raise ValueError("aucun canal disponible")
PY

cat >relay/relay/server.py <<'PY'
from http.server import BaseHTTPRequestHandler, HTTPServer


class Handler(BaseHTTPRequestHandler):
    def do_POST(self):
        self.send_response(202)
        self.end_headers()


def serve(port: int) -> None:
    HTTPServer(("", port), Handler).serve_forever()
PY

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_NAME="Théo Vasseur" GIT_AUTHOR_EMAIL="theo.vasseur@example.invalid"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME" GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
export GIT_AUTHOR_DATE="2026-10-01T10:00:00Z" GIT_COMMITTER_DATE="2026-10-01T10:00:00Z"
git -c core.hooksPath=/dev/null add relay
git -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q \
  -m "feat(relay): service de relais des notifications"
