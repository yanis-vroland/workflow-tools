---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Inventaire des versions[^\n]*\n(?=(?:(?!\n## )[\s\S])*?\bbcryptjs\b)(?=(?:(?!\n## )[\s\S])*?\bcors\b)(?=(?:(?!\n## )[\s\S])*?\bexpress\b)(?=(?:(?!\n## )[\s\S])*?\bjsonwebtoken\b)(?=(?:(?!\n## )[\s\S])*?\bpg\b)(?=(?:(?!\n## )[\s\S])*?(?<![\w@/-])react(?![\w-]))(?=(?:(?!\n## )[\s\S])*?\breact-dom\b)(?=(?:(?!\n## )[\s\S])*?@types/express\b)(?=(?:(?!\n## )[\s\S])*?@types/react(?![\w-]))(?=(?:(?!\n## )[\s\S])*?@types/react-dom\b)(?=(?:(?!\n## )[\s\S])*?@vitejs/plugin-react\b)(?=(?:(?!\n## )[\s\S])*?\beslint\b)(?=(?:(?!\n## )[\s\S])*?\btsx\b)(?=(?:(?!\n## )[\s\S])*?\btypescript\b)(?=(?:(?!\n## )[\s\S])*?\bvite\b)(?=(?:(?!\n## )[\s\S])*?\bvitest\b)(?=(?:(?!\n## )[\s\S])*?(?<![\w/.-])http(?![\w:-]))(?=(?:(?!\n## )[\s\S])*?\bsqflite\b)(?=(?:(?!\n## )[\s\S])*?(?<![\w/.-])path(?![\w-]))(?=(?:(?!\n## )[\s\S])*?\bshared_preferences\b)(?=(?:(?!\n## )[\s\S])*?\bgeolocator\b)(?=(?:(?!\n## )[\s\S])*?\bimage_picker\b)(?=(?:(?!\n## )[\s\S])*?\bjson_annotation\b)(?=(?:(?!\n## )[\s\S])*?\bbuild_runner\b)(?=(?:(?!\n## )[\s\S])*?\bjson_serializable\b)(?=(?:(?!\n## )[\s\S])*?\bflutter_lints\b)'
match: contains
---

CA3 : « Inventaire des versions » cite chacune des 16 dépendances directes de `package.json` et des 10 dépendances hébergées de `mobile/pubspec.yaml` (les dépendances du SDK `flutter` et `flutter_test` ne sont pas exigées).
