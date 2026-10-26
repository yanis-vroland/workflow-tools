---
type: regex
target: { source: file, path: ".npmrc" }
pattern: '127\.0\.0\.1:9'
match: contains
---

Témoin : le scaffold a bien configuré un registre npm injoignable.
