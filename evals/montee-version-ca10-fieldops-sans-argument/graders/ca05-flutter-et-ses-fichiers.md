---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Inventaire des versions[^\n]*\n(?=(?:(?!\n## )[\s\S])*?>=3\.1\.0 <4\.0\.0)(?=(?:(?!\n## )[\s\S])*?>=3\.13\.0)(?=(?:(?!\n## )[\s\S])*?\.fvmrc)(?=(?:(?!\n## )[\s\S])*?3\.13\.9)(?=(?:(?!\n## )[\s\S])*?pubspec\.yaml)(?=(?:(?!\n## )[\s\S])*?\bstable\b)'
match: contains
---

CA5 : « Inventaire des versions » cite la contrainte du SDK Dart (`>=3.1.0 <4.0.0`), la contrainte Flutter (`>=3.13.0`), la version épinglée par `mobile/.fvmrc` (3.13.9), avec leurs fichiers, et la dernière version stable de Flutter (publiée, ou « non déterminé »).
