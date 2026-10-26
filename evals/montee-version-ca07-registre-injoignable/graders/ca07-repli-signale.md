---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Points non déterminés[^\n]*\n(?=[\s\S]*?(?:registre|réseau))(?=[\s\S]*?(?:lockfile|package-lock\.json|pubspec\.lock|fichiers? de verrouillage))'
flags: i
match: contains
---

CA7 : « Points non déterminés » signale le registre injoignable et le repli sur les versions du lockfile.
