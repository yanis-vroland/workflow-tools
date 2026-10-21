#!/usr/bin/env bash
# FieldOps web seul, arbre propre, faux secret généré, plus un commit rejouable
# qui ajoute le paiement par carte via le SDK Stripe (dépendance « stripe » dans
# package.json et package-lock.json, src/services/cardPayment.ts, variable
# STRIPE_SECRET_KEY dans .env.example).
# Seule variable dont le service est établi par le code : STRIPE_SECRET_KEY.
# Les autres clés (MAP_API_KEY, MAIL_API_KEY, PAYMENT_API_KEY) sont lues par des
# appels fetch vers une URL configurable, sans service identifié.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops-web.sh" "$PWD"

mkdir -p src/services
cat >src/services/cardPayment.ts <<'TS'
// Paiement des acomptes par carte bancaire
import Stripe from "stripe";

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY ?? "");

export async function createCardDeposit(amountCents: number, customerEmail: string) {
  return stripe.paymentIntents.create({
    amount: amountCents,
    currency: "eur",
    receipt_email: customerEmail,
  });
}
TS

awk '{
  if ($0 ~ /^    "react-dom": "\^17\.0\.2"$/) {
    print $0 ","
    print "    \"stripe\": \"^14.25.0\""
  } else {
    print
  }
}' package.json >package.json.tmp
mv package.json.tmp package.json
grep -q '"stripe"' package.json

# package-lock.json cohérent avec package.json : dépendance racine et entrée
# node_modules/stripe (insérée après celle de react-dom)
awk '{
  if ($0 ~ /^        "react-dom": "\^17\.0\.2"$/) {
    print $0 ","
    print "        \"stripe\": \"^14.25.0\""
  } else if ($0 ~ /"resolved": "https:\/\/registry\.npmjs\.org\/react-dom\/-\/react-dom-17\.0\.2\.tgz"$/) {
    print
    getline
    print
    print "    \"node_modules/stripe\": {"
    print "      \"version\": \"14.25.0\","
    print "      \"resolved\": \"https://registry.npmjs.org/stripe/-/stripe-14.25.0.tgz\""
    print "    },"
  } else {
    print
  }
}' package-lock.json >package-lock.json.tmp
mv package-lock.json.tmp package-lock.json
[ "$(grep -c 'stripe' package-lock.json)" -eq 3 ]

cat >>.env.example <<'ENV'

# Paiement par carte (acomptes)
STRIPE_SECRET_KEY=changeme
ENV

export GIT_CONFIG_NOSYSTEM=1
export GIT_CONFIG_GLOBAL=/dev/null
export TZ=UTC
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE

g() {
  git -c core.hooksPath=/dev/null -c commit.gpgsign=false -c core.autocrlf=false "$@"
}

g add -- src/services/cardPayment.ts package.json package-lock.json .env.example
export GIT_AUTHOR_NAME="Hugo Brassac" GIT_AUTHOR_EMAIL="hugo.brassac@example.invalid"
export GIT_COMMITTER_NAME="Hugo Brassac" GIT_COMMITTER_EMAIL="hugo.brassac@example.invalid"
export GIT_AUTHOR_DATE="2026-10-02T09:00:00Z" GIT_COMMITTER_DATE="2026-10-02T09:00:00Z"
g commit -q -m "feat(payment): paiement des acomptes par carte"
