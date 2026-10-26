#!/usr/bin/env bash
# Application iOS native fictive (Swift, projet Xcode), sans pubspec.yaml ni
# package.json (spec 015, CA4). L'outil doit indiquer que l'iOS natif
# (Swift/Xcode) n'est pas couvert en v1 et n'écrire aucun livrable.
set -euo pipefail

mkdir -p Releves.xcodeproj Releves

cat >Releves.xcodeproj/project.pbxproj <<'PBX'
// !$*UTF8*$!
{
	archiveVersion = 1;
	objectVersion = 56;
	objects = {
		7A1B2C3D4E5F60718293A4B5 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				IPHONEOS_DEPLOYMENT_TARGET = 16.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.example.releves;
				SWIFT_VERSION = 5.0;
			};
			name = Release;
		};
	};
}
PBX

cat >Releves/Info.plist <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDisplayName</key>
	<string>Relevés</string>
</dict>
</plist>
PLIST

cat >Releves/RelevesApp.swift <<'SWIFT'
import SwiftUI

@main
struct RelevesApp: App {
    var body: some Scene {
        WindowGroup {
            Text("Relevés du jour")
        }
    }
}
SWIFT

cat >README.md <<'MD'
# Relevés

Application iOS native de saisie des relevés de compteurs.
MD
