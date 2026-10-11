#!/usr/bin/env python3
"""Génère un PDF minimal, sans dépendance, pour les evals (spec 004).

Usage :
  build-pdf.py <destination.pdf> <page1.txt> [<page2.txt> ...]
      une page par fichier texte, texte extractible (Helvetica, WinAnsi)
  build-pdf.py --no-text <destination.pdf> <page1.txt> [<page2.txt> ...]
      une page par fichier texte, texte lisible à l'œil mais non extractible :
      chaque lettre est dessinée en petits carrés pleins (police matricielle
      5 x 7), sans aucun opérateur de texte, à la manière d'un document scanné
      (004-CA17)

Les données des pages sont fictives et fournies par le scaffold de chaque cas.
"""
import sys
import unicodedata

PAGE_WIDTH = 595
PAGE_HEIGHT = 842


def escape(line: str) -> bytes:
    raw = line.encode("cp1252", errors="replace")
    return raw.replace(b"\\", b"\\\\").replace(b"(", b"\\(").replace(b")", b"\\)")


def text_stream(text: str) -> bytes:
    parts = [b"BT /F1 11 Tf 15 TL 50 790 Td"]
    for line in text.splitlines():
        parts.append(b"(" + escape(line) + b") Tj T*")
    parts.append(b"ET")
    return b"\n".join(parts)


# Police matricielle 5 x 7 : sept lignes de cinq colonnes par caractère
GLYPHS = {
    "A": ["01110", "10001", "10001", "11111", "10001", "10001", "10001"],
    "B": ["11110", "10001", "10001", "11110", "10001", "10001", "11110"],
    "C": ["01110", "10001", "10000", "10000", "10000", "10001", "01110"],
    "D": ["11110", "10001", "10001", "10001", "10001", "10001", "11110"],
    "E": ["11111", "10000", "10000", "11110", "10000", "10000", "11111"],
    "F": ["11111", "10000", "10000", "11110", "10000", "10000", "10000"],
    "G": ["01110", "10001", "10000", "10111", "10001", "10001", "01111"],
    "H": ["10001", "10001", "10001", "11111", "10001", "10001", "10001"],
    "I": ["01110", "00100", "00100", "00100", "00100", "00100", "01110"],
    "J": ["00111", "00010", "00010", "00010", "00010", "10010", "01100"],
    "K": ["10001", "10010", "10100", "11000", "10100", "10010", "10001"],
    "L": ["10000", "10000", "10000", "10000", "10000", "10000", "11111"],
    "M": ["10001", "11011", "10101", "10101", "10001", "10001", "10001"],
    "N": ["10001", "11001", "10101", "10011", "10001", "10001", "10001"],
    "O": ["01110", "10001", "10001", "10001", "10001", "10001", "01110"],
    "P": ["11110", "10001", "10001", "11110", "10000", "10000", "10000"],
    "Q": ["01110", "10001", "10001", "10001", "10101", "10010", "01101"],
    "R": ["11110", "10001", "10001", "11110", "10100", "10010", "10001"],
    "S": ["01111", "10000", "10000", "01110", "00001", "00001", "11110"],
    "T": ["11111", "00100", "00100", "00100", "00100", "00100", "00100"],
    "U": ["10001", "10001", "10001", "10001", "10001", "10001", "01110"],
    "V": ["10001", "10001", "10001", "10001", "10001", "01010", "00100"],
    "W": ["10001", "10001", "10001", "10101", "10101", "10101", "01010"],
    "X": ["10001", "10001", "01010", "00100", "01010", "10001", "10001"],
    "Y": ["10001", "10001", "01010", "00100", "00100", "00100", "00100"],
    "Z": ["11111", "00001", "00010", "00100", "01000", "10000", "11111"],
    "0": ["01110", "10001", "10011", "10101", "11001", "10001", "01110"],
    "1": ["00100", "01100", "00100", "00100", "00100", "00100", "01110"],
    "2": ["01110", "10001", "00001", "00010", "00100", "01000", "11111"],
    "3": ["11111", "00010", "00100", "00010", "00001", "10001", "01110"],
    "4": ["00010", "00110", "01010", "10010", "11111", "00010", "00010"],
    "5": ["11111", "10000", "11110", "00001", "00001", "10001", "01110"],
    "6": ["00110", "01000", "10000", "11110", "10001", "10001", "01110"],
    "7": ["11111", "00001", "00010", "00100", "01000", "01000", "01000"],
    "8": ["01110", "10001", "10001", "01110", "10001", "10001", "01110"],
    "9": ["01110", "10001", "10001", "01111", "00001", "00010", "01100"],
    ":": ["00000", "01100", "01100", "00000", "01100", "01100", "00000"],
    ".": ["00000", "00000", "00000", "00000", "00000", "01100", "01100"],
    ",": ["00000", "00000", "00000", "00000", "01100", "00100", "01000"],
    "-": ["00000", "00000", "00000", "11111", "00000", "00000", "00000"],
    "'": ["00100", "00100", "01000", "00000", "00000", "00000", "00000"],
    "(": ["00010", "00100", "01000", "01000", "01000", "00100", "00010"],
    ")": ["01000", "00100", "00010", "00010", "00010", "00100", "01000"],
    " ": ["00000"] * 7,
}
DOT = 1.6  # côté d'un carré, en points
ADVANCE = 6 * DOT  # largeur d'un caractère, espacement compris
LEADING = 10 * DOT  # hauteur d'une ligne


def plain(line: str) -> str:
    # Majuscules sans accents : la police matricielle n'a que A-Z, chiffres et ponctuation
    decomposed = unicodedata.normalize("NFKD", line.upper())
    return "".join(ch for ch in decomposed if not unicodedata.combining(ch))


def glyph_stream(text: str) -> bytes:
    # Texte dessiné en carrés pleins (opérateur re) : visible au rendu, mais aucun
    # opérateur de texte (BT, Tj), donc rien à extraire
    parts = [b"0.1 g"]
    top = 790.0
    for row, line in enumerate(text.splitlines()):
        baseline = top - row * LEADING
        for col, char in enumerate(plain(line)):
            pattern = GLYPHS.get(char, GLYPHS[" "])
            x0 = 50 + col * ADVANCE
            for gy, bits in enumerate(pattern):
                for gx, bit in enumerate(bits):
                    if bit == "1":
                        x = x0 + gx * DOT
                        y = baseline - gy * DOT
                        parts.append(f"{x:.1f} {y:.1f} {DOT} {DOT} re".encode())
        parts.append(b"f")
    return b"\n".join(parts)


def build(streams: list) -> bytes:
    objects = []
    page_count = len(streams)
    font_id = 3
    first_page_id = 4
    kids = " ".join(f"{first_page_id + 2 * i} 0 R" for i in range(page_count))
    objects.append(b"<< /Type /Catalog /Pages 2 0 R >>")
    objects.append(f"<< /Type /Pages /Kids [{kids}] /Count {page_count} >>".encode())
    objects.append(b"<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>")
    for i, stream in enumerate(streams):
        page_id = first_page_id + 2 * i
        objects.append(
            (
                f"<< /Type /Page /Parent 2 0 R /MediaBox [0 0 {PAGE_WIDTH} {PAGE_HEIGHT}] "
                f"/Resources << /Font << /F1 {font_id} 0 R >> >> /Contents {page_id + 1} 0 R >>"
            ).encode()
        )
        objects.append(
            f"<< /Length {len(stream)} >>\nstream\n".encode() + stream + b"\nendstream"
        )

    out = bytearray(b"%PDF-1.4\n%\xe2\xe3\xcf\xd3\n")
    offsets = []
    for number, body in enumerate(objects, start=1):
        offsets.append(len(out))
        out += f"{number} 0 obj\n".encode() + body + b"\nendobj\n"
    xref = len(out)
    out += f"xref\n0 {len(objects) + 1}\n0000000000 65535 f \n".encode()
    for offset in offsets:
        out += f"{offset:010d} 00000 n \n".encode()
    out += f"trailer\n<< /Size {len(objects) + 1} /Root 1 0 R >>\nstartxref\n{xref}\n%%EOF\n".encode()
    return bytes(out)


def main(argv: list) -> int:
    if len(argv) >= 3 and argv[0] == "--no-text":
        destination, paths, render = argv[1], argv[2:], glyph_stream
    elif len(argv) >= 2 and not argv[0].startswith("-"):
        destination, paths, render = argv[0], argv[1:], text_stream
    else:
        print(__doc__, file=sys.stderr)
        return 2
    streams = []
    for path in paths:
        with open(path, encoding="utf-8") as handle:
            streams.append(render(handle.read()))
    with open(destination, "wb") as handle:
        handle.write(build(streams))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
