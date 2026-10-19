---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '^(?:(?!\n## )[\s\S])*?\b21bc390'
match: contains
---

CA3 (ADR-001) : l'en-tête donne le commit analysé (HEAD du scaffold, déterministe : 21bc390).
