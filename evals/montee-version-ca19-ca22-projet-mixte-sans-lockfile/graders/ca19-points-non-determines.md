---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Points non déterminés[^\n]*\n[\s\S]*?(?:lockfile|fichier de verrouillage|package-lock)'
flags: i
match: contains
---

CA19 : « Points non déterminés » signale l'absence de lockfile (versions installées non déterminées).
