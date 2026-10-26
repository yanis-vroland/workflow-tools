#!/usr/bin/env bash
# Application Android native fictive (Kotlin, Gradle en Kotlin DSL), sans
# application Flutter ni JavaScript (spec 015, CA4). L'outil doit indiquer que
# l'Android natif (Kotlin/Gradle) n'est pas couvert en v1 et n'écrire aucun
# livrable.
set -euo pipefail

mkdir -p app/src/main/java/com/example/fieldops/scanner

cat >settings.gradle.kts <<'KTS'
rootProject.name = "fieldops-scanner"
include(":app")
KTS

cat >build.gradle.kts <<'KTS'
plugins {
    id("com.android.application") version "8.2.2" apply false
    id("org.jetbrains.kotlin.android") version "1.9.22" apply false
}
KTS

cat >app/build.gradle.kts <<'KTS'
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.example.fieldops.scanner"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.fieldops.scanner"
        minSdk = 26
        targetSdk = 34
        versionCode = 5
        versionName = "0.5.0"
    }
}
KTS

cat >app/src/main/AndroidManifest.xml <<'XML'
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.CAMERA" />
    <application android:label="FieldOps Scanner" android:icon="@mipmap/ic_launcher">
        <activity android:name=".MainActivity" android:exported="true" />
    </application>
</manifest>
XML

cat >app/src/main/java/com/example/fieldops/scanner/MainActivity.kt <<'KT'
package com.example.fieldops.scanner

import android.app.Activity
import android.os.Bundle

class MainActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }
}
KT

cat >README.md <<'MD'
# FieldOps Scanner

Application Android native de lecture des étiquettes d'équipement.

```bash
./gradlew assembleDebug
```
MD
