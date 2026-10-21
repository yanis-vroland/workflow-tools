#!/usr/bin/env bash
# Spec 012, CA5 (et CA4 pour integration_test) : FieldOps complet, dans lequel
#   - l'application Flutter déclare integration_test (mobile/pubspec.yaml) et
#     contient un test d'intégration (mobile/integration_test/app_test.dart),
#     commités le 2026-10-01 ;
#   - deux rapports de couverture, produits avant ce dernier commit (fichiers
#     datés du 2026-09-15 10:00 UTC) et non suivis par git :
#     coverage/coverage-summary.json (web, Vitest) et mobile/coverage/lcov.info
#     (Flutter, flutter test --coverage).
# Arbre de travail propre : coverage/ est ignoré par .gitignore, mobile/coverage/
# est exclu par .git/info/exclude.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC

# --- integration_test déclaré et un test d'intégration --------------------------
awk '{ print } /^  flutter_test:$/ { getline; print; print "  integration_test:"; print "    sdk: flutter" }' \
  mobile/pubspec.yaml >mobile/pubspec.yaml.tmp
mv mobile/pubspec.yaml.tmp mobile/pubspec.yaml

mkdir -p mobile/integration_test
cat >mobile/integration_test/app_test.dart <<'DART'
import 'package:fieldops_companion/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("l'application démarre", (tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
DART

export GIT_AUTHOR_NAME="Nora Belkacem" GIT_AUTHOR_EMAIL="nora.belkacem@example.invalid"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME" GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
export GIT_AUTHOR_DATE="2026-10-01T10:00:00Z" GIT_COMMITTER_DATE="2026-10-01T10:00:00Z"
git -c core.hooksPath=/dev/null add mobile/pubspec.yaml mobile/integration_test/app_test.dart
git -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q \
  -m "test(mobile): test d'intégration du démarrage de l'application"

# --- Rapports de couverture antérieurs au dernier commit ------------------------
mkdir -p coverage mobile/coverage
cat >coverage/coverage-summary.json <<'JSON'
{
  "total": {
    "lines": { "total": 22, "covered": 18, "skipped": 0, "pct": 81.82 },
    "statements": { "total": 24, "covered": 19, "skipped": 0, "pct": 79.17 },
    "functions": { "total": 3, "covered": 3, "skipped": 0, "pct": 100 },
    "branches": { "total": 8, "covered": 5, "skipped": 0, "pct": 62.5 }
  },
  "src/domain/invoice.ts": {
    "lines": { "total": 22, "covered": 18, "skipped": 0, "pct": 81.82 },
    "statements": { "total": 24, "covered": 19, "skipped": 0, "pct": 79.17 },
    "functions": { "total": 3, "covered": 3, "skipped": 0, "pct": 100 },
    "branches": { "total": 8, "covered": 5, "skipped": 0, "pct": 62.5 }
  }
}
JSON

cat >mobile/coverage/lcov.info <<'LCOV'
SF:lib/utils/duration_format.dart
DA:2,2
DA:3,2
DA:4,0
DA:6,2
DA:7,2
DA:8,2
DA:9,1
DA:11,1
LF:8
LH:7
end_of_record
LCOV

echo "mobile/coverage/" >>.git/info/exclude
touch -t 202609151000 coverage/coverage-summary.json mobile/coverage/lcov.info

if [ -n "$(git status --porcelain)" ]; then
  echo "Arbre de travail non propre après le scaffold." >&2
  git status --short >&2
  exit 1
fi
