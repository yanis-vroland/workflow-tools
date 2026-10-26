---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Documentation de r[ée]f[ée]rence[^\n]*\n(?:(?!\n##? )[\s\S])*?\]\((?:\./)?onboarding\.md\)'
match: contains
---

CA3 : « Documentation de référence » liste le livrable wf-onboarding par un lien relatif (`onboarding.md`).
