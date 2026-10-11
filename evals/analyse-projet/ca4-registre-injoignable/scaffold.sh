#!/usr/bin/env bash
# Spec 001, CA4 : registre de paquets injoignable.
#
# Le réseau de l'agent ne peut pas être coupé depuis le scaffold : son
# environnement n'est pas transmis à la session, et execution.env n'accepte que
# des variables EVAL_* (npm_config_registry est donc impossible). Le réseau est
# coupé par le bac à sable de Claude Code : ce cas se lance SANS autorisation
# WebFetch(domain:…), ce qui interdit tout accès réseau aux commandes Bash
# (voir evals/README.md). En complément, un .npmrc projet redirige npm vers un
# registre injoignable, au cas où le cas serait lancé avec ces autorisations ;
# il est exclu par .git/info/exclude pour garder l'arbre de travail propre.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

printf 'registry=http://127.0.0.1:9/\n' >.npmrc
printf '.npmrc\n' >>.git/info/exclude
