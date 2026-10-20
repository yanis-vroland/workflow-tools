#!/usr/bin/env node
// Vérifie les correcteurs des evals de wf-tests-manquants (evals/tests-manquants-*/)
// et les commandes Bash prescrites par la skill, sans modèle.
//
// 1. Chaque motif (`pattern`, `input_match`) des case.yaml compile comme dans
//    `claude plugin eval` (new RegExp du runtime JavaScript).
// 2. Aucune commande Bash prescrite par skills/wf-tests-manquants/SKILL.md n'est
//    attrapée par un correcteur Bash « max: 0 » : sinon la skill suivie à la
//    lettre échouerait à l'eval (cas constaté : la liste d'extensions
//    `(ts|tsx|…|dart|…)` de l'inventaire prise pour un lancement de `tsx`).
// 3. Le correcteur des lanceurs (CA7) attrape les lancements de tests,
//    d'installation et de couverture, et laisse passer les lectures.
// 4. Les commandes prescrites n'insèrent aucun texte du projet : le seul
//    élément à substituer est `<commande de l'étape 2>` (injection shell).
//
// Usage : node tests/correcteurs/wf-tests-manquants.mjs

import { readdirSync, readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..", "..");
let errors = 0;
const ok = (m) => console.log(`OK     correcteurs wf-tests-manquants : ${m}`);
const ko = (m) => {
  console.log(`ÉCHEC  correcteurs wf-tests-manquants : ${m}`);
  errors++;
};

// Lit les graders d'un case.yaml (valeurs simples, entre apostrophes YAML : '' = ')
function graders(file) {
  const list = [];
  let cur = null;
  for (const line of readFileSync(file, "utf8").split("\n")) {
    let m;
    if ((m = /^  - name: (\S+)/.exec(line))) list.push((cur = { name: m[1] }));
    else if (cur && (m = /^    (\w+): '(.*)'$/.exec(line))) cur[m[1]] = m[2].replace(/''/g, "'");
    else if (cur && (m = /^    (\w+): "(.*)"$/.exec(line))) cur[m[1]] = m[2];
    else if (cur && (m = /^    (\w+): (.*)$/.exec(line))) cur[m[1]] = m[2].trim();
  }
  return list;
}

const evals = join(root, "evals");
const cases = readdirSync(evals).filter((d) => d.startsWith("tests-manquants-"));
const bashZero = [];
for (const c of cases) {
  for (const g of graders(join(evals, c, "case.yaml"))) {
    for (const key of ["pattern", "input_match"]) {
      if (!g[key]) continue;
      try {
        const re = new RegExp(g[key], key === "pattern" ? g.flags || "" : "");
        if (key === "input_match" && g.tool === "Bash" && g.max === "0") bashZero.push({ c, g, re });
      } catch (e) {
        ko(`${c} ${g.name} ne compile pas (${e.message})`);
      }
    }
  }
}
ok(`${cases.length} cas, motifs compilés`);

// --- Commandes prescrites par la skill -----------------------------------------
const skill = readFileSync(join(root, "skills", "wf-tests-manquants", "SKILL.md"), "utf8");
// Chaque bloc avec la dernière ligne non vide qui le précède : un bloc annoncé
// « dans git seulement » n'est jamais exécuté hors git.
const blocks = [...skill.matchAll(/^```bash\n([\s\S]*?)^```$/gm)].map((m) => {
  const before = skill.slice(0, m.index).trimEnd().split("\n").pop();
  return { text: m[1].trimEnd(), gitOnly: /dans git seulement/i.test(before) };
});
if (blocks.length < 4) ko(`blocs bash de la skill trouvés : ${blocks.length}, attendu au moins 4`);
const inventory = blocks.find((b) => b.text.includes("git ls-files --cached"))?.text;
if (!inventory) ko("bloc d'inventaire (étape 2) introuvable");
const bash = (command) => JSON.stringify({ command, description: "Commande de la skill" });

// Élément à substituer : « <mots en minuscules> » (pas « <<< », ni « 2> »)
const placeholdersOf = (text) =>
  (text.match(/<[a-zà-ÿ@][a-zà-ÿ0-9 '’_@-]*>/g) || []).filter((p) => p !== "<commande de l'étape 2>");

for (const [i, { text, gitOnly }] of blocks.entries()) {
  const placeholders = placeholdersOf(text);
  if (placeholders.length) ko(`bloc bash ${i + 1} : élément à substituer ${placeholders.join(", ")} (texte du projet dans une commande)`);
  const command = text.replaceAll("<commande de l'étape 2>", inventory ?? "");
  for (const { c, g, re } of bashZero) {
    // Ce correcteur ne vaut que hors git : seuls les blocs « dans git seulement » y échappent
    if (gitOnly && g.name === "ca18-aucun-historique-interroge") continue;
    if (re.test(bash(command))) ko(`bloc bash ${i + 1} attrapé par ${c} ${g.name}`);
  }
}
ok(`${blocks.length} blocs bash de la skill confrontés aux correcteurs Bash « max: 0 »`);

// Commandes en code en ligne (`git …`, `date …`, `find …`, `ls …`) : même règle
// d'injection que les blocs, aucun élément du projet à substituer.
const inline = [...skill.matchAll(/`((?:git|date|find|ls)\b[^`\n]*)`/g)].map((m) => m[1]);
for (const span of inline) {
  const placeholders = placeholdersOf(span);
  if (placeholders.length) ko(`commande en ligne « ${span} » : élément à substituer ${placeholders.join(", ")}`);
}
ok(`${inline.length} commandes en ligne vérifiées (aucun texte du projet à substituer)`);

// --- Correcteur des lanceurs (CA7) -----------------------------------------------
const lanceurs = bashZero.find(({ g }) => g.name.startsWith("ca07-aucun-lanceur"));
if (!lanceurs) {
  ko("correcteur ca07-aucun-lanceur-… introuvable");
} else {
  const positives = [
    "npm test",
    "npx vitest run",
    "cd mobile && flutter test --coverage",
    "FOO=1 node x.js",
    "pnpm install",
    "fvm flutter test",
    "vitest run",
    "env CI=1 npm run test",
    "python3 -m pytest",
    "cd mobile; dart test",
    "ls && yarn",
    "(npm test)",
    "cat package.json | node -e 'x'",
    "true\nnpm ci",
  ];
  const negatives = [
    inventory ?? "",
    "grep -c vitest package.json",
    "grep -E '\\.(ts|tsx|dart|node)$' liste.txt",
    "date -r coverage/lcov.info +%F",
    "git rev-parse --short HEAD",
    "find . -name '*_test.dart' | wc -l",
    "grep -rn --exclude='.env*' 'flutter_test' mobile/pubspec.yaml",
    "ls -A",
  ];
  for (const c of positives) if (!lanceurs.re.test(bash(c))) ko(`lanceur non détecté : ${JSON.stringify(c)}`);
  for (const c of negatives) if (lanceurs.re.test(bash(c))) ko(`lecture prise pour un lanceur : ${JSON.stringify(c)}`);
  ok("correcteur des lanceurs sur exemples positifs et négatifs");
}

process.exit(errors ? 1 : 0);
