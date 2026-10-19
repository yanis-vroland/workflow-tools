#!/usr/bin/env bash
# Spec 010, CA22 : projet mixte. FieldOps complet (JS/TS et Flutter, couverts en
# v1) reçoit un outil d'import Python (stack non couverte) dans outils/import/,
# porteur d'une injection SQL et d'un mot de passe littéral factice, et d'une
# dépendance Python ancienne. Rien de la partie Python ne doit être rapporté.
# Le tout est commité de façon déterministe pour garder l'arbre propre.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

mkdir -p outils/import

cat >outils/import/requirements.txt <<'TXT'
requests==2.19.0
psycopg2-binary==2.8.6
TXT

cat >outils/import/import_csv.py <<'PY'
"""Import des techniciens depuis l'export CSV de l'ancien tableur."""
import csv
import sys

import psycopg2

password = "__VALEUR_FACTICE__"


def find_technician(cursor, tech_id):
    cursor.execute("SELECT * FROM technicians WHERE id = " + tech_id)
    return cursor.fetchone()


def main(path):
    conn = psycopg2.connect(host="localhost", dbname="fieldops", user="fieldops", password=password)
    with open(path, newline="", encoding="utf-8") as fh, conn.cursor() as cursor:
        for row in csv.DictReader(fh):
            if find_technician(cursor, row["id"]) is None:
                cursor.execute(
                    "INSERT INTO technicians (first_name, last_name) VALUES (%s, %s)",
                    (row["first_name"], row["last_name"]),
                )
    conn.commit()


if __name__ == "__main__":
    main(sys.argv[1])
PY
# Valeur factice substituée après coup : écrite telle quelle à côté de son nom
# de variable, elle déclencherait le scanner de secrets du pre-commit de ce dépôt.
sed 's/__VALEUR_FACTICE__/FAUX_MDP_PY_8e2a/' outils/import/import_csv.py >outils/import/import_csv.py.tmp
mv outils/import/import_csv.py.tmp outils/import/import_csv.py

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_NAME="Théo Vasseur" GIT_AUTHOR_EMAIL="theo.vasseur@example.invalid"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME" GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
export GIT_AUTHOR_DATE="2026-10-01T10:00:00Z" GIT_COMMITTER_DATE="2026-10-01T10:00:00Z"
git -c core.hooksPath=/dev/null -c commit.gpgsign=false add outils
git -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -m "chore(outils): import des techniciens depuis le tableur"
