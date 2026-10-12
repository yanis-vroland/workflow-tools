#!/usr/bin/env bash
# Projet fictif en Python, stack non couverte en v1 (spec 003, CA18) : service
# de relais des notifications de FieldOps. Le guide doit s'appuyer sur le
# README, le Makefile, le Dockerfile et la CI. Dépôt git avec un commit.
set -euo pipefail

mkdir -p relay tests .github/workflows

cat >README.md <<'MD'
# FieldOps Relay

Service qui relaie les notifications de FieldOps vers les techniciens.

## Démarrage

```bash
make install
make run
```

Le service écoute sur le port 8080.
MD

cat >Makefile <<'MAKE'
.PHONY: install run test lint

install:
	pip install -e ".[dev]"

run:
	python -m relay

test:
	pytest

lint:
	ruff check relay tests
MAKE

cat >pyproject.toml <<'TOML'
[project]
name = "fieldops-relay"
version = "0.3.0"
requires-python = ">=3.11"
dependencies = ["httpx>=0.27"]

[project.optional-dependencies]
dev = ["pytest>=8", "ruff>=0.5"]
TOML

cat >Dockerfile <<'DOCKER'
FROM python:3.11-slim
WORKDIR /app
COPY . .
RUN pip install .
CMD ["python", "-m", "relay"]
DOCKER

cat >.github/workflows/ci.yml <<'YAML'
name: CI
on: [push]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"
      - run: make install
      - run: make lint
      - run: make test
YAML

cat >relay/__init__.py <<'PY'
PY

cat >relay/__main__.py <<'PY'
from relay.server import serve

serve(port=8080)
PY

cat >relay/server.py <<'PY'
from http.server import BaseHTTPRequestHandler, HTTPServer


class Handler(BaseHTTPRequestHandler):
    def do_POST(self):
        self.send_response(202)
        self.end_headers()


def serve(port: int) -> None:
    HTTPServer(("", port), Handler).serve_forever()
PY

cat >relay/models.py <<'PY'
from dataclasses import dataclass


@dataclass
class Notification:
    """Message à transmettre à un technicien au sujet d'une intervention."""

    technician_id: int
    intervention_id: int
    text: str
PY

cat >tests/test_models.py <<'PY'
from relay.models import Notification


def test_notification_keeps_text():
    assert Notification(1, 2, "Bonjour").text == "Bonjour"
PY

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_DATE="2026-09-01T09:00:00Z" GIT_COMMITTER_DATE="2026-09-01T09:00:00Z"
git -c init.defaultBranch=main init -q
git add -A
git -c user.name="FieldOps" -c user.email="fieldops@example.invalid" \
  -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -m "feat: service de relais des notifications"
