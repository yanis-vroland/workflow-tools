---
type: regex
target: { source: file, path: ".env.md" }
pattern: 'CADRAGE_FAUX_SECRET_4b9e'
match: contains
---

Témoin : le scaffold a bien créé `.env.md` avec le marqueur, sinon « adr001-secret-absent » réussirait sans rien prouver.
