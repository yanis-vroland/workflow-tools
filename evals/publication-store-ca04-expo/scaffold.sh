#!/usr/bin/env bash
# Application mobile Expo fictive (flux géré : ni ios/ ni android/, configuration
# dans app.json), sans application Flutter (spec 015, CA4). L'outil doit
# indiquer « Expo non couvert en v1 » et n'écrire aucun livrable.
set -euo pipefail

mkdir -p app

cat >package.json <<'JSON'
{
  "name": "fieldops-releves",
  "version": "1.0.0",
  "private": true,
  "main": "expo-router/entry",
  "scripts": {
    "start": "expo start",
    "android": "expo run:android",
    "ios": "expo run:ios"
  },
  "dependencies": {
    "expo": "~50.0.6",
    "expo-camera": "~14.0.4",
    "expo-router": "~3.4.7",
    "react": "18.2.0",
    "react-native": "0.73.4"
  }
}
JSON

cat >app.json <<'JSON'
{
  "expo": {
    "name": "FieldOps Relevés",
    "slug": "fieldops-releves",
    "version": "1.0.0",
    "ios": { "bundleIdentifier": "com.example.fieldops.releves" },
    "android": { "package": "com.example.fieldops.releves" },
    "plugins": ["expo-camera"]
  }
}
JSON

cat >app/index.tsx <<'TSX'
import { Text, View } from "react-native";

export default function Home() {
  return (
    <View>
      <Text>Relevés de compteurs</Text>
    </View>
  );
}
TSX

cat >README.md <<'MD'
# FieldOps Relevés

Application Expo de relevé des compteurs sur site.

```bash
npm install
npx expo start
```
MD
