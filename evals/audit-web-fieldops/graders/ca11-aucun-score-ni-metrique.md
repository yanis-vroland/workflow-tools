---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\b(?:LCP|CLS|INP|FCP|TBT|TTFB|Speed Index)\b[^\n]{0,20}?\d|score[^\n]{0,30}?\b\d{1,3}\s*(?:/\s*100|%)|\b\d+(?:[.,]\d+)?\s*(?:ms|millisecondes?|secondes?)\b'
flags: "i"
match: not_contains
---

CA11 : mode code seul (aucune URL passée), aucun score ni métrique mesurée (score Lighthouse, LCP, CLS, INP, temps de chargement) n'apparaît dans le livrable.
