---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Installer le projet[^\n]*\n(?:(?!\n##? )[\s\S])*?non déterminé'
flags: i
match: contains
---

CA4 : sans commande d'installation dans les fichiers du projet, « Installer le
projet » écrit « non déterminé ».
