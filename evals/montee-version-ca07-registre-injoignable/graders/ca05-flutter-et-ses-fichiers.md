---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Inventaire des versions[^\n]*\n(?=(?:(?!\n## )[\s\S])*?>=3\.1\.0 <4\.0\.0)(?=(?:(?!\n## )[\s\S])*?>=3\.13\.0)(?=(?:(?!\n## )[\s\S])*?\.fvmrc)(?=(?:(?!\n## )[\s\S])*?3\.13\.9)'
match: contains
---

CA5 : même sans réseau, les contraintes du SDK Dart et de Flutter et la version épinglée par `mobile/.fvmrc` sont citées.
