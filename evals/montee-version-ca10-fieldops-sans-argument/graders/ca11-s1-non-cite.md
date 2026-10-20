---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '^(?:(?!\n## Points non déterminés)[\s\S])*?\bS1\b'
match: not_contains
---

CA11 : seules les entrées de « Dépendances vulnérables » sont reprises ; `S1`, constat dans le code du livrable de sécurité, n'apparaît dans aucune section avant « Points non déterminés » (ni synthèse, ni cible, ni rupture, ni étape). Le mentionner dans « Points non déterminés » comme hors périmètre reste permis.
