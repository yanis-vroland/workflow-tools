#!/usr/bin/env bash
# Projet fictif en Python (spec 014, CA18) : service de relais des notifications
# de FieldOps, avec une route HTTP, sans docs/specs/ ni docs/wf/specs-tickets.md.
# Stack non couverte en v1 : aucun livrable. Dépôt git avec un commit.
set -euo pipefail

mkdir -p relay
cat >README.md <<'MD'
# FieldOps Relay

Service qui relaie les notifications de FieldOps vers les techniciens.
MD
cat >pyproject.toml <<'TOML'
[project]
name = "fieldops-relay"
version = "0.3.0"
requires-python = ">=3.11"
dependencies = ["flask>=3"]
TOML
cat >relay/__init__.py <<'PY'
PY
cat >relay/app.py <<'PY'
from flask import Flask, jsonify, request

app = Flask(__name__)


@app.post("/notifications")
def create_notification():
    payload = request.get_json()
    if not payload or "technician_id" not in payload:
        return jsonify({"error": "technician_id manquant"}), 400
    return jsonify({"status": "queued"}), 202
PY

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_DATE="2026-09-01T09:00:00Z" GIT_COMMITTER_DATE="2026-09-01T09:00:00Z"
git -c init.defaultBranch=main init -q
git add -A
git -c user.name="FieldOps" -c user.email="fieldops@example.invalid" \
  -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -m "feat: service de relais des notifications"
