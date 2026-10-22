#!/usr/bin/env bash
# Tests structurels de la skill wf-publication-store (spec 015, ADR-001 et
# amendements 1 et 2).
#
# Sans modèle : on vérifie que skills/wf-publication-store/SKILL.md existe, passe
# la vérification commune (.github/scripts/verifier-skills.sh), et cite les
# libellés que la spec 015 impose mot pour mot dans le livrable (titres de
# sections, colonnes, statuts, mentions fixes, limites des stores, chemins). Le
# comportement réel est vérifié par les evals evals/publication-store-*/.
set -u

root="$(cd "$(dirname "$0")/../.." && pwd)"
skill_dir="$root/skills/wf-publication-store"
skill="$skill_dir/SKILL.md"
fail=0

ok() { echo "OK     wf-publication-store : $1"; }
ko() {
  echo "ÉCHEC  wf-publication-store : $1"
  fail=1
}

# --- Présence et conformité commune ---------------------------------------------

if [ ! -f "$skill" ]; then
  ko "SKILL.md présent (skills/wf-publication-store/SKILL.md introuvable)"
  exit 1
fi
ok "SKILL.md présent"

work=$(mktemp -d)
trap 'rm -r "$work"' EXIT
mkdir -p "$work/skills"
cp -R "$skill_dir" "$work/skills/"
if out=$(bash "$root/.github/scripts/verifier-skills.sh" "$work/skills" 2>&1); then
  ok "frontmatter et consignes communes de l'ADR-001"
else
  ko "frontmatter et consignes communes de l'ADR-001 ($out)"
fi

# Corps de la skill, sans le frontmatter
end=$(awk 'NR > 1 && $0 == "---" { print NR; exit }' "$skill")
body=$(sed -n "$((${end:-0} + 1)),\$p" "$skill")

# cite <description> <fragment exact>
cite() {
  if grep -qF -- "$2" <<<"$body"; then
    ok "$1"
  else
    ko "$1 (« $2 » absent du corps)"
  fi
}

# --- CA1 : emplacement du livrable ---------------------------------------------

cite "CA1 livrable docs/wf/publication-store.md" "docs/wf/publication-store.md"

# --- CA2 : sections dans l'ordre ------------------------------------------------

sections=(
  "Synthèse"
  "Identité de l'application"
  "Checklist iOS"
  "Checklist Android"
  "Fiches store"
  "Étapes hors projet"
  "Points non déterminés"
)
# Titres « ## » du bloc modèle du livrable (```markdown … ```) seulement : une
# mention d'une section ailleurs dans la skill ne doit pas fausser l'ordre.
model=$(awk '/^```markdown$/ { in_block = 1; next } in_block && /^```$/ { exit } in_block' <<<"$body")
titles=()
while IFS= read -r line; do
  titles+=("${line#\#\# }")
done < <(grep -E '^## ' <<<"$model")
if [ -z "$model" ]; then
  ko "CA2 bloc modèle du livrable (\`\`\`markdown) présent"
elif [ "${titles[*]}" != "${sections[*]}" ]; then
  ko "CA2 titres ## du modèle (attendu : ${sections[*]} ; obtenu : ${titles[*]})"
else
  ok "CA2 les sept sections, dans l'ordre"
fi

# --- CA3 : application Flutter dans un sous-dossier --------------------------------

cite "CA3 pubspec.yaml déclarant la dépendance flutter" "pubspec.yaml"
cite "CA3 dépendance flutter" "sdk: flutter"

# --- CA4 et CA5 : stack non couverte, aucune application mobile --------------------

cite "CA4 mention « non couvert en v1 »" "non couvert en v1"
cite "CA4 React Native détecté" "React Native"
cite "CA4 Expo détecté" "Expo"
cite "CA4 natif Swift/Xcode détecté" "Xcode"
# Un projet Xcode est un dossier : Glob ne le trouve que par un fichier qu'il contient
cite "CA4 projet Xcode repéré par son project.pbxproj" "**/*.xcodeproj/project.pbxproj"
cite "CA4 natif Kotlin/Gradle détecté" "Kotlin"
cite "CA5 message « aucune application mobile »" "Aucune application mobile"

# --- CA6 : identité -------------------------------------------------------------

cite "CA6 bundle identifier iOS" "PRODUCT_BUNDLE_IDENTIFIER"
cite "CA6 applicationId Android" "applicationId"
cite "CA6 mention « non déterminé »" "non déterminé"

# --- CA7 : tableaux des checklists ------------------------------------------------

cite "CA7 colonnes du tableau" "| Élément | Statut | Bloquant | Fichier | Détail |"
cite "CA7 statut « OK »" "OK"
cite "CA7 statut « à faire »" "à faire"
cite "CA7 statut « à vérifier »" "à vérifier"
cite "CA7 statut « non applicable »" "non applicable"

# --- CA8 : éléments de la checklist iOS --------------------------------------------

cite "CA8 icône 1024×1024" "1024"
cite "CA8 AppIcon.appiconset" "AppIcon.appiconset"
cite "CA8 descriptions d'usage NS*UsageDescription" "UsageDescription"
cite "CA8 Info.plist" "Info.plist"
cite "CA8 cible de déploiement minimale" "IPHONEOS_DEPLOYMENT_TARGET"
cite "CA8 équipe de signature" "DEVELOPMENT_TEAM"
cite "CA8 manifeste de confidentialité" "PrivacyInfo.xcprivacy"

# --- CA9 : éléments de la checklist Android ----------------------------------------

cite "CA9 icônes mipmap-*" "mipmap-"
cite "CA9 permissions uses-permission" "uses-permission"
cite "CA9 minSdk" "minSdk"
cite "CA9 targetSdk" "targetSdk"
cite "CA9 signature du type de build release" "signingConfig"

# --- CA10, CA11 et CA14 : signature et permissions vides ----------------------------

cite "CA11 signature avec la configuration debug" "signingConfigs.debug"
cite "CA14 mot de passe en clair (storePassword)" "storePassword"

# --- CA12 : fichiers sensibles ----------------------------------------------------

for sensitive in "key.properties" "*.jks" "*.keystore" "*.p12" "*.p8" \
  "*.mobileprovision" "GoogleService-Info.plist" "google-services.json"; do
  cite "CA12 fichier sensible $sensitive" "$sensitive"
done

cite "CA12 configuration FlutterFire jamais ouverte" "firebase_options.dart"
cite "CA12 et ADR-001 : Grep en mode files_with_matches" 'output_mode: "files_with_matches"'

# --- CA13 : fichier de clés suivi par git ------------------------------------------

cite "CA13 commande git ls-files des fichiers de clés" \
  "git ls-files -- '*key.properties' '*.jks' '*.keystore' '*.p12' '*.p8'"
cite "CA13 renvoi à wf-revue-securite" "/wf-revue-securite"

# --- CA15 et CA16 : exigences qui évoluent, réseau indisponible ----------------------

cite "CA15 page officielle Google Play (targetSdk)" \
  "https://developer.android.com/google/play/requirements/target-sdk"
cite "CA15 page officielle Apple (SDK et Xcode)" \
  "https://developer.apple.com/news/upcoming-requirements/"
cite "CA15 date de consultation" "consulté le"
cite "CA16 documentation non consultée" "la documentation des stores n'a pas pu être consultée"

# --- CA17 : verdict -------------------------------------------------------------

cite "CA17 verdict « prêt à soumettre »" "prêt à soumettre"
cite "CA17 verdict « non prêt »" "non prêt"

# --- CA18 à CA21 : fiches store et nouveautés -------------------------------------

cite "CA18 métadonnées fastlane/metadata/" "fastlane/metadata/"
cite "CA18 mention « brouillon à valider »" "brouillon à valider"
cite "CA19 livrable de wf-release-notes" "docs/wf/release-notes.md"
cite "CA19 rubrique « Nouveautés de cette version »" "Nouveautés de cette version"
cite "CA19 section de version (contrat de la spec 009)" "## Version"
cite "CA19 mention « texte de nouveautés à rédiger à la main »" \
  "texte de nouveautés à rédiger à la main"
cite "CA20 mention « à vérifier : notes de version »" "à vérifier : notes de version"
cite "CA21 suggestion de lancer /wf-release-notes" "/wf-release-notes"

# --- CA22 : limites des stores ----------------------------------------------------

cite "CA22 mention « dépasse la limite »" "dépasse la limite"
cite "CA22 limite du nom (30)" "nom 30"
cite "CA22 limite du sous-titre iOS (30)" "sous-titre iOS 30"
cite "CA22 limite des mots-clés iOS (100)" "mots-clés iOS 100"
cite "CA22 limite de la description courte Android (80)" "description courte Android 80"
cite "CA22 limite de la description complète (4000)" "description complète 4000"
cite "CA22 limite des nouveautés iOS (4000)" "nouveautés iOS 4000"
cite "CA22 limite des nouveautés Android (500)" "nouveautés Android 500"

# --- CA23 : étapes hors projet ----------------------------------------------------

cite "CA23 captures d'écran" "captures d'écran"
cite "CA23 App Privacy" "App Privacy"
cite "CA23 Data safety" "Data safety"
cite "CA23 classification du contenu" "classification du contenu"
cite "CA23 compte de démonstration" "compte de démonstration"

# --- CA26 et CA27 : en-tête et secrets ----------------------------------------------

cite "CA26 mention « hors git »" "hors git"
cite "CA26 mention « modifications non commitées »" "modifications non commitées"
cite "CA27 seul .env.example peut être lu" ".env.example"

# --- Commandes Bash fixes, sans texte venu du projet (injection shell) -------------
# La liste blanche est la liste à puces qui suit « Bash ne sert qu'à » : exactement
# les quatre commandes attendues, aucune avec $, backtick ou guillemet double.

expected_commands=(
  "git rev-parse --short HEAD"
  "git status --porcelain"
  "git ls-files -- '*key.properties' '*.jks' '*.keystore' '*.p12' '*.p8'"
  "date +%F"
)
commands=()
while IFS= read -r line; do
  commands+=("$line")
done < <(awk '/Bash ne sert qu.à/ { in_list = 1; next }
  in_list && /^  - `.*`$/ { sub(/^  - `/, ""); sub(/`$/, ""); print; next }
  in_list && /^- / { exit }' <<<"$body")
if [ "${commands[*]-}" != "${expected_commands[*]}" ]; then
  ko "liste blanche Bash (attendu : ${expected_commands[*]} ; obtenu : ${commands[*]-})"
else
  inject=0
  for command in "${commands[@]}"; do
    case $command in
      *'$'* | *'`'* | *'"'*) inject=1 ;;
    esac
  done
  if [ "$inject" -eq 1 ]; then
    ko "liste blanche Bash sans \$, backtick ni guillemet double"
  else
    ok "liste blanche Bash : quatre commandes fixes, sans texte interpolé"
  fi
fi

# --- Aucune valeur propre à la fixture FieldOps -----------------------------------
# Les exemples de la skill restent génériques : sinon les evals sur FieldOps
# mesureraient la recopie d'un exemple, pas le comportement (surapprentissage).

fieldops_values=(
  "FieldOps"
  "fieldops"
  "com.example"
  "1.2.0+14"
  "mobile/pubspec.yaml"
  "targetSdkVersion 33"
  "minSdkVersion 21"
  "NSCameraUsageDescription"
  "NSPhotoLibraryUsageDescription"
  "fvm"
  "flutterVersion"
  "FLUTTER_BUILD"
  "upload-keystore"
  "AuthKey"
  "technicien"
  "superviseur"
  "ImageSource"
  "Geolocator"
)
leak_ok=1
for value in "${fieldops_values[@]}"; do
  if grep -qF -- "$value" <<<"$body"; then
    ko "aucune valeur de FieldOps dans la skill (« $value » présent)"
    leak_ok=0
  fi
done
[ "$leak_ok" -eq 1 ] && ok "aucune valeur de FieldOps dans la skill"

# Extraction automatique : jetons nommés (avec « _ », « . », « - » ou en
# camelCase, 6 caractères ou plus) des scaffolds des cas et de l'application
# mobile de la fixture. Un jeton présent dans la skill (mot entier, casse
# ignorée) doit être un nom imposé par la spec ou un nom standard d'outillage
# Flutter, iOS, Android ou fastlane, listé ci-dessous.
allowed_tokens=" androidmanifest.xml appicon.appiconset applicationid assets.xcassets
  build.gradle build.gradle.kts buildtypes com.android.application contents.json
  description.txt developer.android.com developer.apple.com firebase_options.dart
  full_description.txt google-services.json googleservice-info.plist info.plist
  iphoneos_deployment_target key.properties keypassword keywords.txt minsdk
  minsdkversion name.txt package.json product_bundle_identifier project.pbxproj
  publication-store.md pubspec.yaml react-native readme.md release-notes.md
  short_description.txt signingconfig signingconfigs signingconfigs.debug
  sous-section storepassword subtitle.txt targetsdk targetsdkversion title.txt
  uses-permission wf-publication-store wf-release-notes "
body_lower=$(tr '[:upper:]' '[:lower:]' <<<"$body")
auto_ok=1
while IFS= read -r token; do
  lower=$(tr '[:upper:]' '[:lower:]' <<<"$token")
  case $allowed_tokens in *[[:space:]]"$lower"[[:space:]]*) continue ;; esac
  if grep -qwF -- "$lower" <<<"$body_lower"; then
    ko "aucun nom des cas ni de la fixture mobile dans la skill (« $token » présent)"
    auto_ok=0
  fi
done < <({
  cat "$root"/evals/publication-store-*/scaffold.sh
  find "$root/tests/fixtures/fieldops/mobile" -type f -exec cat {} +
} | grep -oE '\b[A-Za-z][A-Za-z0-9]*([_.-][A-Za-z0-9]+)+|\b[a-z]+[A-Z][A-Za-z0-9]*' |
  awk 'length($0) >= 6' | sort -u)
[ "$auto_ok" -eq 1 ] && ok "aucun nom des cas ni de la fixture mobile dans la skill (extraction automatique)"

# --- Cas reseau sans la chaîne « hors-reseau » ----------------------------------------
# Un lanceur qui choisit la passe par une recherche de « hors-reseau » dans le
# case.yaml (série r15) lancerait un cas reseau sans WebFetch si un nom de
# correcteur contenait cette chaîne.

reseau_ok=1
for case_file in "$root"/evals/publication-store-*/case.yaml; do
  if grep -qE '^tags:.*\breseau\b' "$case_file" && ! grep -qE '^tags:.*hors-reseau' "$case_file" &&
    grep -q 'hors-reseau' "$case_file"; then
    ko "cas reseau sans la chaîne hors-reseau (${case_file#"$root"/})"
    reseau_ok=0
  fi
done
[ "$reseau_ok" -eq 1 ] && ok "cas reseau sans la chaîne hors-reseau"

# --- Motifs des correcteurs des evals (compilation, exemples) -----------------------

if out=$(node "$root/tests/correcteurs/wf-publication-store.mjs" 2>&1); then
  ok "motifs des correcteurs des evals (tests/correcteurs/wf-publication-store.mjs)"
else
  ko "motifs des correcteurs des evals ($out)"
fi

exit $fail
