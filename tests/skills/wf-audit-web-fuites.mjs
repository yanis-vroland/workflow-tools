#!/usr/bin/env node
// Anti-fuite de wf-audit-web : aucune valeur propre aux données des evals (fixture
// FieldOps et cas evals/audit-web-*) ne doit figurer dans le corps de SKILL.md, sinon
// la skill soufflerait la réponse aux correcteurs (surapprentissage).
//
// Les valeurs sont extraites automatiquement des scaffolds, prompts et correcteurs des
// cas, et des fichiers de la fixture FieldOps : noms de fichiers, chemins, hash,
// nombres, identifiants (CamelCase, MAJUSCULES_SOULIGNÉES). La comparaison ignore la
// casse. Une courte liste de valeurs partagées légitimement (fixées par la spec ou
// propres à l'outil) est exclue, chacune avec sa raison.
//
// Usage : node tests/skills/wf-audit-web-fuites.mjs <SKILL.md> [valeur injectée]
//   Avec une valeur injectée (contrôle par mutation), elle est ajoutée au corps et
//   doit être détectée.

import { readFileSync, readdirSync, statSync, existsSync } from "node:fs";
import { dirname, join, basename } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..", "..");
const [skillPath, injected] = process.argv.slice(2);

// Valeurs partagées légitimement, avec leur raison
const ALLOWED = new Map(
  Object.entries({
    "docs/wf/audit-web.md": "livrable fixé par CA1",
    "audit-web.md": "livrable fixé par CA1",
    "scripts/lighthouse-summary.mjs": "script de la skill",
    "lighthouse-summary.mjs": "script de la skill",
    "package.json": "manifeste générique",
    "pubspec.yaml": "manifeste générique (CA21)",
    "composer.json": "manifeste générique (CA22)",
    ".env.example": "consigne commune de l'ADR-001",
    "env.example": "consigne commune de l'ADR-001",
    "next/image": "composant image de Next.js cité par CA6",
    "webfetch": "nom d'outil",
    "wf_url_4b1d": "délimiteur du heredoc prescrit",
    "200": "seuil de CA10 (200 Ko)",
    "000": "seuil de CA10 (200 000 octets)",
    "200000": "seuil de CA10",
    "2.4.2": "critère WCAG",
    "1.1.1": "critère WCAG",
    "3.1.1": "critère WCAG",
    "1.3.1": "critère WCAG",
    "4.1.2": "critère WCAG",
    "100": "échelle des scores Lighthouse (CA14)",
    "js/ts": "stack couverte (spec, CA20)",
    "next.js": "framework cité par CA6",
    "http/2": "point d'hébergeur générique (CA28)",
    "vercel.json": "fichier de configuration d'hébergeur générique (CA28), cité aussi par le correcteur",
    "node_modules": "dossier exclu générique",
  }),
);

function walk(dir, out = []) {
  for (const name of readdirSync(dir)) {
    const p = join(dir, name);
    if (name === ".git" || name === "node_modules") continue;
    const st = statSync(p);
    if (st.isDirectory()) walk(p, out);
    else out.push(p);
  }
  return out;
}

const sources = [];
const evals = join(root, "evals");
for (const c of readdirSync(evals).filter((d) => d.startsWith("audit-web-"))) {
  for (const f of walk(join(evals, c))) sources.push({ path: f, text: readFileSync(f, "utf8") });
}
const fixture = join(root, "tests", "fixtures", "fieldops");
if (existsSync(fixture)) {
  for (const f of walk(fixture)) {
    sources.push({ path: f, text: f.replace(fixture + "/", "") }); // chemins de la fixture
    if (/\.(?:ts|tsx|html|json|ya?ml|md|sql|dart|svg)$/.test(f)) sources.push({ path: f, text: readFileSync(f, "utf8") });
  }
}

const PATTERNS = [
  /[\w-]+(?:\.[\w-]+)*\.(?:tsx?|jsx?|html?|php|json|svg|png|jpe?g|md|ya?ml|sql|dart|mjs)\b/g, // fichiers
  /\b[\w-]+(?:\/[\w.-]+)+/g, // chemins
  /\b(?=[0-9a-f]*\d)(?=[0-9a-f]*[a-f])[0-9a-f]{7}\b/g, // hash courts
  /\b\d{3,}(?:[   ]\d{3})*\b/g, // nombres
  /\b[A-Z][a-z0-9]+(?:[A-Z][a-z0-9]*)+\b/g, // CamelCase
  /\b[A-Za-z][A-Za-z0-9]*_[A-Za-z0-9_]+\b/g, // MAJUSCULES_SOULIGNÉES et délimiteurs
  /\b[A-Z][a-z]{3,}(?=%s|\$\{?\w)/g, // préfixes de noms générés (printf, variables)
];

const PREFIX = PATTERNS[PATTERNS.length - 1];
const values = new Map();
const prefixes = new Set();
for (const { path, text } of sources) {
  const clean = text.replace(/\\/g, "");
  for (const re of PATTERNS) {
    for (const m of clean.matchAll(re)) {
      const v = m[0].toLowerCase().replace(/\.+$/, "");
      if (v.length < 3 || ALLOWED.has(v)) continue;
      if (!values.has(v)) values.set(v, basename(dirname(path)) + "/" + basename(path));
      if (re === PREFIX) prefixes.add(v);
    }
  }
}

// Auto-contrôle : l'extraction trouve bien des valeurs connues des cas
for (const known of ["ecran", "bandeau.png", "interventionlist", "src/web/legacy", "fieldops_faux_secret_7f3a"]) {
  if (!values.has(known)) {
    console.log(`ÉCHEC  anti-fuite : l'extraction ne trouve pas « ${known} »`);
    process.exit(1);
  }
}

const skill = readFileSync(skillPath, "utf8");
const end = skill.indexOf("\n---", 4);
let body = (end > 0 ? skill.slice(end + 4) : skill).toLowerCase();
if (injected) body += "\n" + injected.toLowerCase();

const leaks = [];
for (const [v, from] of values) {
  const escaped = v.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  // Un préfixe de nom généré peut être suivi de son numéro (ex. préfixe puis 001)
  const after = prefixes.has(v) ? "(?![a-z/-])" : "(?![\\w/-]|\\.\\w)";
  if (new RegExp(`(?<![\\w./-])${escaped}${after}`).test(body)) leaks.push(`${v} (${from})`);
}
if (leaks.length) {
  console.log(`ÉCHEC  anti-fuite : valeurs des evals dans la skill : ${leaks.join(", ")}`);
  process.exit(1);
}
console.log(`OK     anti-fuite : ${values.size} valeurs des evals absentes de la skill`);
