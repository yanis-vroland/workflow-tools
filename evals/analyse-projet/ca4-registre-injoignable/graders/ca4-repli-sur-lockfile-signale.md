---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Points non déterminés[^\n]*\n[\s\S]*?(?:lockfile|package-lock\.json|pubspec\.lock|fichiers? de verrouillage)'
flags: mi
match: contains
---

CA4 : « Points non déterminés » indique le repli sur les versions du lockfile.
