#!/usr/bin/env bash
# Copie la fixture FieldOps brief (projet pas encore démarré, ni code ni git) dans
# le répertoire de travail de l'eval, vide au lancement.
# Y ajoute un cahier des charges .docx fictif (format non pris en charge).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
cp -R "$repo/tests/fixtures/fieldops-brief/." "$PWD"
python3 - "$PWD/cahier-des-charges.docx" <<'PY'
import sys
import zipfile

document = (
    '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
    '<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">'
    "<w:body><w:p><w:r><w:t>Géolocalisation en temps réel des véhicules des techniciens"
    " (indispensable).</w:t></w:r></w:p></w:body></w:document>"
)
types = (
    '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
    '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
    '<Default Extension="xml" ContentType="application/xml"/>'
    '<Override PartName="/word/document.xml" ContentType="application/'
    'vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/></Types>'
)
with zipfile.ZipFile(sys.argv[1], "w") as archive:
    archive.writestr("[Content_Types].xml", types)
    archive.writestr("word/document.xml", document)
PY
