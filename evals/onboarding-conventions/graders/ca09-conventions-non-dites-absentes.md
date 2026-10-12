---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '(?:branches|commits)[^\n]*non d[ée]termin|aucune convention de contribution'
flags: i
match: not_contains
---

CA9 : les conventions définies par `CONTRIBUTING.md` et `commitlint.config.js`
ne sont pas déclarées « non déterminé », et le guide ne dit pas qu'il n'y a
aucune convention de contribution.
