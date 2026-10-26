#!/usr/bin/env bash
# Application mobile React Native fictive (sans Expo), sans application Flutter
# (spec 015, CA4) : ios/ et android/ présents, mais pas de pubspec.yaml. L'outil
# doit indiquer « React Native non couvert en v1 » et n'écrire aucun livrable.
set -euo pipefail

mkdir -p src ios/FieldOpsTerrain.xcodeproj ios/FieldOpsTerrain android/app/src/main

cat >package.json <<'JSON'
{
  "name": "fieldops-terrain",
  "version": "0.9.0",
  "private": true,
  "scripts": {
    "android": "react-native run-android",
    "ios": "react-native run-ios",
    "start": "react-native start",
    "test": "jest"
  },
  "dependencies": {
    "react": "18.2.0",
    "react-native": "0.73.4"
  },
  "devDependencies": {
    "@react-native/babel-preset": "0.73.21",
    "jest": "^29.6.3"
  }
}
JSON

cat >app.json <<'JSON'
{
  "name": "FieldOpsTerrain",
  "displayName": "FieldOps Terrain"
}
JSON

cat >index.js <<'JS'
import { AppRegistry } from "react-native";
import App from "./src/App";
import { name as appName } from "./app.json";

AppRegistry.registerComponent(appName, () => App);
JS

cat >src/App.tsx <<'TSX'
import React from "react";
import { SafeAreaView, Text } from "react-native";

export default function App() {
  return (
    <SafeAreaView>
      <Text>Interventions du jour</Text>
    </SafeAreaView>
  );
}
TSX

cat >ios/FieldOpsTerrain/Info.plist <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDisplayName</key>
	<string>FieldOps Terrain</string>
	<key>CFBundleIdentifier</key>
	<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
</dict>
</plist>
PLIST

cat >ios/FieldOpsTerrain.xcodeproj/project.pbxproj <<'PBX'
// !$*UTF8*$!
{
	archiveVersion = 1;
	objectVersion = 54;
	objects = {
		13B07F941A680F5B00A75B9A /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				IPHONEOS_DEPLOYMENT_TARGET = 13.4;
				PRODUCT_BUNDLE_IDENTIFIER = com.example.fieldops.terrain;
			};
			name = Debug;
		};
	};
}
PBX

cat >android/app/build.gradle <<'GRADLE'
apply plugin: "com.android.application"
apply plugin: "com.facebook.react"

android {
    namespace "com.example.fieldops.terrain"
    defaultConfig {
        applicationId "com.example.fieldops.terrain"
        minSdkVersion 23
        targetSdkVersion 34
        versionCode 9
        versionName "0.9.0"
    }
}
GRADLE

cat >android/app/src/main/AndroidManifest.xml <<'XML'
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <application android:label="FieldOps Terrain" android:icon="@mipmap/ic_launcher" />
</manifest>
XML

cat >README.md <<'MD'
# FieldOps Terrain

Application React Native des techniciens FieldOps.

```bash
npm install
npm run android
```
MD
