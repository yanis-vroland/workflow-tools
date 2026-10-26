#!/usr/bin/env node
// Vérifie les motifs des correcteurs des evals de wf-publication-store
// (evals/publication-store-*/case.yaml) sans modèle : chaque motif compile
// comme le fait `claude plugin eval` (`new RegExp(input_match)` sur l'entrée de
// l'outil sérialisée en JSON, `new RegExp(pattern, flags)` sur le texte visé),
// et les correcteurs renforcés attrapent leurs exemples positifs et laissent
// passer leurs négatifs. Lancé par tests/skills/wf-publication-store.sh.
//
// Usage : node tests/correcteurs/wf-publication-store.mjs

import { readdirSync, readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..", "..");
const evals = join(root, "evals");

// Lit les correcteurs d'un case.yaml : nom, puis clés simples (valeurs entre
// apostrophes YAML, '' = ', ou entre guillemets doubles sans échappement)
function graders(kase) {
  const text = readFileSync(join(evals, kase, "case.yaml"), "utf8");
  const out = {};
  let current = null;
  for (const line of text.split("\n")) {
    const name = /^  - name: (\S+)$/.exec(line);
    if (name) {
      current = out[name[1]] = {};
      continue;
    }
    const field = /^    (\w+):\s*(.*)$/.exec(line);
    if (!current || !field) continue;
    let value = field[2].trim();
    if (value.startsWith("'") && value.endsWith("'")) value = value.slice(1, -1).replace(/''/g, "'");
    else if (value.startsWith('"') && value.endsWith('"')) value = value.slice(1, -1);
    current[field[1]] = value;
  }
  return out;
}

const cases = readdirSync(evals).filter((d) => d.startsWith("publication-store-"));
let failures = 0;
const fail = (message) => {
  console.log(`ÉCHEC  ${message}`);
  failures++;
};

// 1. Tous les motifs compilent
const compiled = {};
for (const kase of cases) {
  for (const [name, g] of Object.entries(graders(kase))) {
    const source = g.input_match ?? g.pattern;
    if (!source) continue;
    try {
      compiled[`${kase}/${name}`] = new RegExp(source, g.input_match ? "" : (g.flags ?? ""));
    } catch (error) {
      fail(`${kase}/${name} : motif invalide (${error.message})`);
    }
  }
}

// 2. Exemples positifs (le motif trouve) et négatifs (il ne trouve pas)
const bash = (command) => JSON.stringify({ command, description: "Commande d'exemple" });
const read = (file_path) => JSON.stringify({ file_path });
const fetch = (url) => JSON.stringify({ url, prompt: "Quel niveau d'API cible Google Play exige-t-il ?" });
const doc = (sections) =>
  [
    "# Préparation",
    "",
    "Outil : wf-publication-store · Date : 2026-10-19 · Commit : 2fc99c0",
    "",
    ...["Synthèse", "Identité de l'application", "Checklist iOS", "Checklist Android", "Fiches store", "Étapes hors projet", "Points non déterminés"].flatMap(
      (s) => [`## ${s}`, "", sections[s] ?? "Contenu.", ""],
    ),
  ].join("\n");
const header = "| Élément | Statut | Bloquant | Fichier | Détail |\n|---|---|---|---|---|";
const row = (cells) => `| ${cells.join(" | ")} |`;

const skillCommands = [
  "git rev-parse --short HEAD",
  "git status --porcelain",
  "git ls-files -- '*key.properties' '*.jks' '*.keystore' '*.p12' '*.p8'",
  "date +%F",
];

const suites = [
  {
    grader: "publication-store-ca03-fieldops/ca01-bash-liste-blanche",
    input: bash,
    positive: ["ls -la", "git ls-files", "flutter build apk", "cat mobile/android/key.properties", "date +%F; curl https://developer.android.com", "git status --porcelain && git add -A"],
    negative: skillCommands,
  },
  {
    grader: "publication-store-ca03-fieldops/ca07-statuts-admis",
    input: doc,
    positive: [
      { "Checklist iOS": `${header}\n${row(["Icône", "manquant", "oui", "`ios/x`", "absent"])}` },
      { "Checklist Android": `${header}\n${row(["minSdk", "KO", "non", "`build.gradle`", "21"])}` },
    ],
    negative: [
      {
        "Checklist iOS": `${header}\n${row(["Icône", "à faire", "oui", "`ios/x`", "absent"])}\n${row(["SDK", "à vérifier", "oui", "`ios/`", "lien"])}`,
        "Checklist Android": `${header}\n${row(["minSdk", "OK", "non", "`build.gradle`", "21"])}\n${row(["x", "non applicable", "non", "`android/`", "-"])}`,
        "Identité de l'application": "| Information | iOS | Android |\n|---|---|---|\n| Nom | Appli | Appli |",
      },
    ],
  },
  {
    grader: "publication-store-ca03-fieldops/ca07-colonne-fichier-renseignee",
    input: doc,
    positive: [{ "Checklist iOS": `${header}\n${row(["Icône", "à faire", "oui", " ", "absent"])}` }],
    negative: [{ "Checklist iOS": `${header}\n${row(["Icône", "à faire", "oui", "`ios/x`", "absent"])}` }],
  },
  {
    grader: "publication-store-ca03-fieldops/ca08-aucune-valeur-ios-inventee",
    input: (t) => t,
    positive: ["IPHONEOS_DEPLOYMENT_TARGET = 12.0", "DEVELOPMENT_TEAM = ABCDE12345", "platform :ios, '13.0'"],
    negative: ["`IPHONEOS_DEPLOYMENT_TARGET` non déterminé", "`DEVELOPMENT_TEAM` : fichier absent", "`platform :ios` du Podfile : absent"],
  },
  {
    grader: "publication-store-ca03-fieldops/ca18-brouillon-complet",
    input: doc,
    positive: [
      {
        "Fiches store":
          "brouillon à valider\n\n### iOS\n\n- Nom : « A » — 1 caractères / limite 30\n- Sous-titre : « B » — 1 caractères / limite 30\n- Mots-clés : « c » — 1 caractères / limite 100\n- Description complète (`README.md`) — 1 caractères / limite 4000 :\n\n### Android\n\n- Description courte : « D » — 1 caractères / limite 80",
      },
    ],
    negative: [
      { "Fiches store": "brouillon à valider\n\n- Nom : « A »\n- Sous-titre : « B »\n- Description courte : « D »\n- Description complète : « E »" },
    ],
  },
  {
    grader: "publication-store-ca03-fieldops/ca16-aucune-exigence-inventee",
    input: (t) => t,
    positive: ["exigence : niveau 35 (consulté le 2026-10-19)"],
    negative: ["la documentation des stores n'a pas pu être consultée"],
  },
  {
    grader: "publication-store-ca12-ca13-ca14-signature/ca12-lecture-fichier-firebase-par-read",
    input: read,
    positive: ["/s/mobile/android/app/google-services.json", "/s/mobile/ios/Runner/GoogleService-Info.plist", "/s/mobile/lib/firebase_options.dart"],
    negative: ["/s/mobile/lib/main.dart", "/s/mobile/ios/Runner/Info.plist"],
  },
  {
    grader: "publication-store-ca12-ca13-ca14-signature/ca13-pas-d-alerte-pour-firebase",
    input: doc,
    positive: [{ Synthèse: "- **Alerte** : fichier `mobile/android/app/google-services.json` ; lancer `/wf-revue-securite`." }],
    negative: [
      {
        Synthèse: "- **Alerte** : fichier de clés suivi par git : `a/key.properties` ; lancer `/wf-revue-securite`.",
        "Checklist Android": "| Fichiers sensibles | OK | non | `a/google-services.json` | présent, non lu |",
      },
    ],
  },
  {
    grader: "publication-store-ca18-ca19-ca20-ca22-fastlane/ca22-une-seule-limite-depassee",
    input: doc,
    positive: [{ "Fiches store": "- A — 126 caractères / limite 80 — dépasse la limite\n- B — 40 caractères / limite 30 — dépasse la limite" }],
    negative: [
      { "Fiches store": "- A — 126 caractères / limite 80 — dépasse la limite", "Points non déterminés": "- La description courte dépasse la limite." },
    ],
  },
  {
    grader: "publication-store-ca24-ca25-deux-applications/ca17-superviseur-pret-a-soumettre",
    input: doc,
    positive: [{ Synthèse: "- **non prêt** (a (`apps/technicien`))\n- **prêt à soumettre** (b (`apps/superviseur`)) — iOS : non applicable" }],
    negative: [{ Synthèse: "- **non prêt** (a (`apps/technicien`))\n- **non prêt** (b (`apps/superviseur`))", "Points non déterminés": "- superviseur : prêt à soumettre ?" }],
  },
  {
    grader: "publication-store-ca24-ca25-deux-applications/ca26-hors-git-sans-mention-de-modifications",
    input: (t) => t,
    positive: ["# T\n\nOutil : wf-publication-store · Date : 2026-10-19 · Commit : hors git · modifications non commitées\n\n## Synthèse\n"],
    negative: ["# T\n\nOutil : wf-publication-store · Date : 2026-10-19 · Commit : hors git\n\n## Synthèse\n\n## Points non déterminés\n\n- Hors git : pas de mention « modifications non commitées ».\n"],
  },
  {
    grader: "publication-store-ca24-ca25-deux-applications/ca26-hors-git-ni-status-ni-ls-files",
    input: bash,
    positive: ["git status --porcelain", "git ls-files -- '*key.properties' '*.jks' '*.keystore' '*.p12' '*.p8'"],
    negative: ["git rev-parse --short HEAD", "date +%F"],
  },
  {
    grader: "publication-store-ca15-documentation-lue/ca15-target-sdk-lu-et-date",
    input: doc,
    positive: [{ "Checklist Android": `${header}\n${row(["targetSdk", "à vérifier", "oui", "`build.gradle`", "33 ; exigence : 35, https://developer.android.com/x (consulté le 2026-10-19)"])}` }],
    negative: [
      { "Checklist Android": `${header}\n${row(["targetSdk", "à vérifier", "oui", "`build.gradle`", "33 ; https://developer.android.com/x"])}` },
      { "Checklist Android": `${header}\n${row(["targetSdk", "OK", "non", "`build.gradle`", "33 ; https://developer.android.com/x (consulté le 2026-10-19)"])}` },
    ],
  },
  {
    grader: "publication-store-ca15-documentation-lue/ca15-aucun-contenu-du-projet-envoye",
    input: fetch,
    positive: ["https://developer.android.com/x?app=com.example.fieldops.companion"],
    negative: ["https://developer.android.com/google/play/requirements/target-sdk", "https://developer.apple.com/news/upcoming-requirements/"],
  },
];

for (const suite of suites) {
  const re = compiled[suite.grader];
  if (!re) {
    fail(`${suite.grader} : correcteur introuvable`);
    continue;
  }
  const errors = [];
  for (const example of suite.positive) {
    if (!re.test(suite.input(example))) errors.push(`positif non détecté : ${JSON.stringify(example)}`);
  }
  for (const example of suite.negative) {
    if (re.test(suite.input(example))) errors.push(`négatif détecté : ${JSON.stringify(example)}`);
  }
  if (errors.length > 0) {
    fail(suite.grader);
    for (const e of errors) console.log(`         ${e}`);
  } else {
    console.log(`OK     ${suite.grader} (${suite.positive.length} positifs, ${suite.negative.length} négatifs)`);
  }
}
console.log(`${Object.keys(compiled).length} motifs compilés.`);
process.exit(failures === 0 ? 0 : 1);
