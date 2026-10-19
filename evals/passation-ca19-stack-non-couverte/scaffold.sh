#!/usr/bin/env bash
# Projet fictif en Python, stack non couverte en v1 (spec 016, CA19) : service
# de génération des rapports de FieldOps. Dépôt git avec un commit.
#   - déploiement : .github/workflows/deploy.yml (flyctl deploy sur push de
#     main, secret FLY_API_TOKEN) et fly.toml (CA5, CA8) ;
#   - Stripe repéré par .env.example (STRIPE_SECRET_KEY) : indice hors
#     dépendances, à lister (CA7) ;
#   - Sentry repéré seulement par requirements.txt : indice de dépendance, à ne
#     pas lister en stack non couverte (CA19) ;
#   - adresse IP écrite en dur (plage de documentation 203.0.113.0/24) dans
#     reports/storage.py ligne 4 (CA23).
set -euo pipefail

mkdir -p reports .github/workflows

cat >README.md <<'MD'
# FieldOps Rapports

Service qui génère les rapports mensuels d'interventions de FieldOps.

## Démarrage

```bash
pip install -r requirements.txt
python -m reports
```
MD

cat >requirements.txt <<'TXT'
flask==3.0.3
stripe==9.9.0
sentry-sdk==2.5.1
TXT

cat >.env.example <<'ENV'
# Paiement des rapports premium
STRIPE_SECRET_KEY=changeme
# Base des rapports
REPORTS_DB_PATH=/data/reports.db
ENV

cat >fly.toml <<'TOML'
app = "fieldops-rapports"
primary_region = "cdg"

[http_service]
  internal_port = 8080
TOML

cat >.github/workflows/deploy.yml <<'YAML'
name: Déploiement
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v4
      - uses: superfly/flyctl-actions/setup-flyctl@master
      - run: flyctl deploy --remote-only
        env:
          FLY_API_TOKEN: ${{ secrets.FLY_API_TOKEN }}
YAML

cat >reports/__init__.py <<'PY'
PY

cat >reports/__main__.py <<'PY'
from reports.app import app

app.run(host="0.0.0.0", port=8080)
PY

cat >reports/app.py <<'PY'
import os

import sentry_sdk
import stripe
from flask import Flask

sentry_sdk.init()
stripe.api_key = os.environ.get("STRIPE_SECRET_KEY", "")

app = Flask(__name__)


@app.get("/reports/<month>")
def monthly_report(month: str):
    # TODO: paginer les interventions du mois
    return {"month": month, "interventions": []}
PY

cat >reports/storage.py <<'PY'
import os

# Copie des rapports sur le serveur d'archives
ARCHIVE_HOST = "203.0.113.42"
DB_PATH = os.environ.get("REPORTS_DB_PATH", "reports.db")
PY

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_DATE="2026-09-01T09:00:00Z" GIT_COMMITTER_DATE="2026-09-01T09:00:00Z"
git -c init.defaultBranch=main init -q
git add -A
git -c user.name="FieldOps" -c user.email="fieldops@example.invalid" \
  -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -m "feat: service de rapports mensuels"
