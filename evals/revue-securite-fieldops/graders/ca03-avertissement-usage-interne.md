---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '^(?=(?:(?!\n## )[\s\S])*?usage interne)(?=(?:(?!\n## )[\s\S])*?non corrig)(?=(?:(?!\n## )[\s\S])*?diffus[^\n]*hors de l.[ée]quipe)'
flags: 'i'
match: contains
---

CA3 : l'en-tête, avant la première section, avertit que le document est à usage interne,
qu'il décrit des failles potentiellement non corrigées et qu'il ne doit pas être diffusé hors
de l'équipe.
