#!/usr/bin/env bash
# Spec 011 (wf-audit-web) sur la fixture FieldOps complète : monorepo avec le
# back-office web React (src/web/) et l'application compagnon Flutter (mobile/),
# historique git, faux fichier d'environnement.
#
# La fixture partagée ne contient aucune image de plus de 200 Ko (CA10) : le
# scaffold ajoute public/img/bandeau.png (PNG valide non compressé, environ
# 260 000 octets, contenu déterministe) et le commite (commit déterministe) pour
# garder l'arbre de travail propre.
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops.sh" "$PWD"

python3 - public/img/bandeau.png <<'PY'
import struct
import sys
import zlib

width, height = 360, 240
rows = b"".join(
    b"\x00" + bytes((x * 7 + y) % 256 for x in range(width) for _ in range(3))
    for y in range(height)
)

def chunk(kind, data):
    return struct.pack(">I", len(data)) + kind + data + struct.pack(">I", zlib.crc32(kind + data))

with open(sys.argv[1], "wb") as out:
    out.write(b"\x89PNG\r\n\x1a\n")
    out.write(chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0)))
    out.write(chunk(b"IDAT", zlib.compress(rows, 0)))
    out.write(chunk(b"IEND", b""))
PY

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_NAME="Nora Belkacem" GIT_AUTHOR_EMAIL="nora.belkacem@example.invalid"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME" GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
export GIT_AUTHOR_DATE="2026-10-02T09:00:00Z" GIT_COMMITTER_DATE="2026-10-02T09:00:00Z"
git -c core.hooksPath=/dev/null -c commit.gpgsign=false add public/img/bandeau.png
git -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -m "feat(web): bandeau de la page d'accueil"
