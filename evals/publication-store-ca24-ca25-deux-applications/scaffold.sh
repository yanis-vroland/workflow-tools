#!/usr/bin/env bash
# Projet hors git contenant deux applications Flutter (spec 015, CA24 à CA26) :
#   - apps/technicien/ : copie de l'application compagnon de FieldOps (iOS et
#     Android, version 1.2.0+14) ;
#   - apps/superviseur/ : application Android seule (pas de dossier ios/),
#     version 0.4.0+3, signature release par key.properties (absent, comme
#     il se doit), icônes de lanceur présentes.
# Pas de dépôt git : l'en-tête doit indiquer « hors git ».
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"

mkdir -p apps
cp -R "$repo/tests/fixtures/fieldops/mobile" apps/technicien

app=apps/superviseur
mkdir -p "$app/lib" "$app/android/app/src/main/res/mipmap-hdpi" \
  "$app/android/app/src/main/res/mipmap-xxxhdpi"

cat >README.md <<'MD'
# FieldOps Mobile

Applications mobiles de FieldOps, logiciel de suivi des interventions de
maintenance :

- `apps/technicien/` : l'application compagnon des techniciens (planning du
  jour, photos, clôture des interventions) ;
- `apps/superviseur/` : l'application des chefs d'équipe, qui suivent
  l'avancement des interventions de leur équipe en temps réel.
MD

cat >"$app/pubspec.yaml" <<'YAML'
name: fieldops_superviseur
description: Suivi des équipes de techniciens FieldOps pour les chefs d'équipe.
publish_to: "none"
version: 0.4.0+3

environment:
  sdk: ">=3.1.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0

flutter:
  uses-material-design: true
YAML

cat >"$app/lib/main.dart" <<'DART'
import 'package:flutter/material.dart';

void main() => runApp(const SupervisorApp());

class SupervisorApp extends StatelessWidget {
  const SupervisorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'FieldOps Superviseur',
      home: Scaffold(body: Center(child: Text('Équipes du jour'))),
    );
  }
}
DART

cat >"$app/android/app/build.gradle" <<'GRADLE'
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
}

def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    namespace "com.example.fieldops.superviseur"
    compileSdkVersion 34

    defaultConfig {
        applicationId "com.example.fieldops.superviseur"
        minSdkVersion 24
        targetSdkVersion 34
        versionCode 3
        versionName "0.4.0"
    }

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}

flutter {
    source '../..'
}
GRADLE

cat >"$app/android/app/src/main/AndroidManifest.xml" <<'XML'
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />

    <application
        android:label="FieldOps Superviseur"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <activity android:name=".MainActivity" android:exported="true" />
    </application>
</manifest>
XML

# Icônes factices : seule leur présence compte pour la checklist
: >"$app/android/app/src/main/res/mipmap-hdpi/ic_launcher.png"
: >"$app/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png"
