#!/usr/bin/env bash
# Spec 011, mode URL sans mesure possible. FieldOps web seul (historique git,
# faux secret), lancé avec une URL en .invalid (jamais résolue, RFC 2606).
#
# Lighthouse n'est installé ni sur les postes de développement ni sur les
# runners de la CI, et le bac à sable de l'eval n'a pas de réseau : le cas
# exerce donc CA17 (Lighthouse absent : pas d'installation, audit du code seul,
# commande d'installation dans « Points non déterminés ») et CA19 (aucune autre
# page chargée). Le témoin ca17-temoin-lighthouse-absent vérifie dans la trace
# que Lighthouse a bien été constaté absent ; sur un poste où il serait
# installé, ce cas exercerait CA16 (URL injoignable) et ce témoin échouerait.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops-web.sh" "$PWD"
