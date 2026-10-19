#!/usr/bin/env bash
# Spec 010 (wf-revue-securite), cas principal sur FieldOps complet (monorepo web
# JS/TS et Flutter), avec le faux fichier d'environnement local de la fixture.
#
# Failles déjà présentes dans la fixture (tests/fixtures/README.md) : requête
# SQL concaténée (src/api/routes/interventions.ts l. 37), route DELETE sans
# authentification (même fichier, l. 82), valeur littérale de repli pour le
# secret JWT (src/api/middleware/auth.ts l. 6), rawQuery interpolée
# (mobile/lib/db/local_db.dart l. 33), jeton dans shared_preferences
# (mobile/lib/services/auth_service.dart l. 24).
#
# Ajouts propres à ce cas, commités pour garder l'arbre propre (commit
# déterministe) :
# - CA6 : dépendance transitive body-parser 1.20.1, introduite par express, dans
#   package-lock.json (versions réelles d'express 4.18.2) ;
# - CA14 : clé factice littérale dans un fichier Dart suivi par git
#   (mobile/lib/services/map_service.dart l. 4), valeur volontairement sans
#   format de vraie clé.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

# CA6 : body-parser 1.20.1, dépendance d'express 4.18.2
awk '
  /^    "node_modules\/express": \{$/ {
    print "    \"node_modules/body-parser\": {"
    print "      \"version\": \"1.20.1\","
    print "      \"resolved\": \"https://registry.npmjs.org/body-parser/-/body-parser-1.20.1.tgz\""
    print "    },"
    in_express = 1
  }
  in_express && /"resolved":/ {
    print $0 ","
    print "      \"dependencies\": {"
    print "        \"body-parser\": \"1.20.1\""
    print "      }"
    in_express = 0
    next
  }
  { print }
' package-lock.json >package-lock.json.tmp
mv package-lock.json.tmp package-lock.json

# CA14 : valeur littérale affectée à une clé dont le nom contient « apikey »
cat >mobile/lib/services/map_service.dart <<'DART'
/// Accès au service de cartographie depuis l'application compagnon.
class MapService {
  static const baseUrl = 'https://maps.example.invalid/v1';
  static const mapApiKey = 'FAUX_JETON_FIELDOPS_c41d';

  Uri geocodeUri(String address) =>
      Uri.parse('$baseUrl/geocode?q=${Uri.encodeQueryComponent(address)}&key=$mapApiKey');
}
DART

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_NAME="Nora Belkacem" GIT_AUTHOR_EMAIL="nora.belkacem@example.invalid"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME" GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
export GIT_AUTHOR_DATE="2026-10-01T10:00:00Z" GIT_COMMITTER_DATE="2026-10-01T10:00:00Z"
git -c core.hooksPath=/dev/null -c commit.gpgsign=false add package-lock.json mobile/lib/services/map_service.dart
git -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -m "feat(mobile): géocodage des adresses depuis l'application compagnon"
