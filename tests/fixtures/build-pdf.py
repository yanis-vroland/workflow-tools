#!/usr/bin/env python3
"""Génère un PDF minimal, sans dépendance, pour les evals (spec 004).

Usage :
  build-pdf.py <destination.pdf> <page1.txt> [<page2.txt> ...]
      une page par fichier texte, texte extractible (Helvetica, WinAnsi)
  build-pdf.py --no-text <destination.pdf> <nombre de pages>
      pages sans aucun texte, seulement des formes dessinées, à la manière
      d'un document scanné dont le texte n'est pas extractible (004-CA17)

Les données des pages sont fictives et fournies par le scaffold de chaque cas.
"""
import sys

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


def shapes_stream(index: int) -> bytes:
    # Bandes grises imitant des lignes de texte numérisées, sans opérateur de texte
    parts = [b"0.6 g"]
    y = 780
    for row in range(30):
        width = 495 - ((row * 37 + index * 11) % 160)
        parts.append(f"50 {y} {width} 8 re f".encode())
        y -= 22
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
        destination, pages = argv[1], int(argv[2])
        streams = [shapes_stream(i) for i in range(pages)]
    elif len(argv) >= 2 and not argv[0].startswith("-"):
        destination = argv[0]
        streams = []
        for path in argv[1:]:
            with open(path, encoding="utf-8") as handle:
                streams.append(text_stream(handle.read()))
    else:
        print(__doc__, file=sys.stderr)
        return 2
    with open(destination, "wb") as handle:
        handle.write(build(streams))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
